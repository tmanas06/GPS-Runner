// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title GovernanceVoting - Vote on New Landmarks and Cities
/// @notice RUN token holders can propose and vote on game expansion
/// @dev Proposal threshold prevents spam, quorum ensures legitimacy
contract GovernanceVoting is Ownable, ReentrancyGuard {
    // ============ Constants ============
    uint256 public constant PROPOSAL_THRESHOLD = 100_000 * 1e18; // 100k RUN to propose
    uint256 public constant VOTING_PERIOD = 7 days;
    uint256 public constant QUORUM_PERCENT = 4; // 4% of total supply
    uint256 public constant EXECUTION_DELAY = 2 days; // Timelock before execution

    // ============ Types ============
    enum ProposalType { NEW_LANDMARK, NEW_CITY, PARAMETER_CHANGE, CUSTOM }
    enum ProposalStatus { Active, Passed, Failed, Executed, Cancelled }

    struct Proposal {
        uint256 id;
        address proposer;
        ProposalType proposalType;
        bytes32 targetHash; // landmarkHash or cityHash
        string description;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 startTime;
        uint256 endTime;
        ProposalStatus status;
        bool executed;
    }

    struct LandmarkProposal {
        string name;
        int256 latitude1e6;
        int256 longitude1e6;
        uint256 radiusMeters;
        bytes32 cityHash;
        uint256 points; // Points awarded for visiting
    }

    struct CityProposal {
        string name;
        bytes32 stateHash;
        int256 minLat1e6;
        int256 maxLat1e6;
        int256 minLng1e6;
        int256 maxLng1e6;
    }

    // ============ State ============
    IERC20 public runToken;

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => LandmarkProposal) public landmarkProposals;
    mapping(uint256 => CityProposal) public cityProposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(uint256 => mapping(address => uint256)) public voteWeight;
    mapping(uint256 => mapping(address => bool)) public votedFor; // true = for, false = against

    // Approved landmarks and cities
    mapping(bytes32 => bool) public approvedLandmarks;
    mapping(bytes32 => bool) public approvedCities;
    mapping(bytes32 => LandmarkProposal) public landmarkDetails;
    mapping(bytes32 => CityProposal) public cityDetails;

    // Delegation
    mapping(address => address) public delegates;
    mapping(address => uint256) public delegatedVotes;

    // ============ Events ============
    event ProposalCreated(
        uint256 indexed proposalId,
        address indexed proposer,
        ProposalType proposalType,
        string description
    );
    event Voted(uint256 indexed proposalId, address indexed voter, bool support, uint256 weight);
    event ProposalExecuted(uint256 indexed proposalId);
    event ProposalCancelled(uint256 indexed proposalId);
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
    event LandmarkApproved(bytes32 indexed landmarkHash, string name, int256 lat, int256 lng);
    event CityApproved(bytes32 indexed cityHash, string name, bytes32 stateHash);

    // ============ Constructor ============
    constructor(address _runToken) Ownable(msg.sender) {
        runToken = IERC20(_runToken);
    }

    // ============ Proposals ============

    /// @notice Propose a new landmark
    function proposeLandmark(
        string calldata name,
        int256 latitude1e6,
        int256 longitude1e6,
        uint256 radiusMeters,
        bytes32 cityHash,
        uint256 points,
        string calldata description
    ) external returns (uint256) {
        require(
            getVotingPower(msg.sender) >= PROPOSAL_THRESHOLD,
            "Insufficient RUN balance"
        );
        require(radiusMeters >= 50 && radiusMeters <= 1000, "Invalid radius");
        require(points >= 1 && points <= 100, "Invalid points");

        proposalCount++;
        uint256 proposalId = proposalCount;

        bytes32 landmarkHash = keccak256(abi.encodePacked(name, latitude1e6, longitude1e6));
        require(!approvedLandmarks[landmarkHash], "Landmark exists");

        proposals[proposalId] = Proposal({
            id: proposalId,
            proposer: msg.sender,
            proposalType: ProposalType.NEW_LANDMARK,
            targetHash: landmarkHash,
            description: description,
            forVotes: 0,
            againstVotes: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + VOTING_PERIOD,
            status: ProposalStatus.Active,
            executed: false
        });

        landmarkProposals[proposalId] = LandmarkProposal({
            name: name,
            latitude1e6: latitude1e6,
            longitude1e6: longitude1e6,
            radiusMeters: radiusMeters,
            cityHash: cityHash,
            points: points
        });

        emit ProposalCreated(proposalId, msg.sender, ProposalType.NEW_LANDMARK, description);
        return proposalId;
    }

    /// @notice Propose a new city
    function proposeCity(
        string calldata name,
        bytes32 stateHash,
        int256 minLat1e6,
        int256 maxLat1e6,
        int256 minLng1e6,
        int256 maxLng1e6,
        string calldata description
    ) external returns (uint256) {
        require(
            getVotingPower(msg.sender) >= PROPOSAL_THRESHOLD,
            "Insufficient RUN balance"
        );
        require(maxLat1e6 > minLat1e6, "Invalid latitude bounds");
        require(maxLng1e6 > minLng1e6, "Invalid longitude bounds");

        proposalCount++;
        uint256 proposalId = proposalCount;

        bytes32 cityHash = keccak256(abi.encodePacked(name));
        require(!approvedCities[cityHash], "City exists");

        proposals[proposalId] = Proposal({
            id: proposalId,
            proposer: msg.sender,
            proposalType: ProposalType.NEW_CITY,
            targetHash: cityHash,
            description: description,
            forVotes: 0,
            againstVotes: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + VOTING_PERIOD,
            status: ProposalStatus.Active,
            executed: false
        });

        cityProposals[proposalId] = CityProposal({
            name: name,
            stateHash: stateHash,
            minLat1e6: minLat1e6,
            maxLat1e6: maxLat1e6,
            minLng1e6: minLng1e6,
            maxLng1e6: maxLng1e6
        });

        emit ProposalCreated(proposalId, msg.sender, ProposalType.NEW_CITY, description);
        return proposalId;
    }

    // ============ Voting ============

    /// @notice Vote on a proposal
    function vote(uint256 proposalId, bool support) external nonReentrant {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.status == ProposalStatus.Active, "Not active");
        require(block.timestamp <= proposal.endTime, "Voting ended");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        uint256 weight = getVotingPower(msg.sender);
        require(weight > 0, "No voting power");

        hasVoted[proposalId][msg.sender] = true;
        voteWeight[proposalId][msg.sender] = weight;
        votedFor[proposalId][msg.sender] = support;

        if (support) {
            proposal.forVotes += weight;
        } else {
            proposal.againstVotes += weight;
        }

        emit Voted(proposalId, msg.sender, support, weight);
    }

    /// @notice Batch vote on multiple proposals
    function batchVote(uint256[] calldata proposalIds, bool[] calldata supportVotes) external nonReentrant {
        require(proposalIds.length == supportVotes.length, "Length mismatch");

        uint256 weight = getVotingPower(msg.sender);
        require(weight > 0, "No voting power");

        for (uint256 i = 0; i < proposalIds.length; i++) {
            uint256 proposalId = proposalIds[i];
            Proposal storage proposal = proposals[proposalId];

            if (
                proposal.status == ProposalStatus.Active &&
                block.timestamp <= proposal.endTime &&
                !hasVoted[proposalId][msg.sender]
            ) {
                hasVoted[proposalId][msg.sender] = true;
                voteWeight[proposalId][msg.sender] = weight;
                votedFor[proposalId][msg.sender] = supportVotes[i];

                if (supportVotes[i]) {
                    proposal.forVotes += weight;
                } else {
                    proposal.againstVotes += weight;
                }

                emit Voted(proposalId, msg.sender, supportVotes[i], weight);
            }
        }
    }

    // ============ Delegation ============

    /// @notice Delegate voting power to another address
    function delegate(address delegatee) external {
        require(delegatee != address(0), "Invalid delegatee");
        require(delegatee != msg.sender, "Cannot self-delegate");

        address oldDelegate = delegates[msg.sender];
        uint256 balance = runToken.balanceOf(msg.sender);

        if (oldDelegate != address(0)) {
            delegatedVotes[oldDelegate] -= balance;
        }

        delegates[msg.sender] = delegatee;
        delegatedVotes[delegatee] += balance;

        emit DelegateChanged(msg.sender, oldDelegate, delegatee);
    }

    /// @notice Remove delegation
    function undelegate() external {
        address oldDelegate = delegates[msg.sender];
        require(oldDelegate != address(0), "Not delegated");

        uint256 balance = runToken.balanceOf(msg.sender);
        delegatedVotes[oldDelegate] -= balance;
        delegates[msg.sender] = address(0);

        emit DelegateChanged(msg.sender, oldDelegate, address(0));
    }

    /// @notice Get voting power (own balance + delegated)
    function getVotingPower(address account) public view returns (uint256) {
        uint256 ownBalance = runToken.balanceOf(account);

        // If delegated, own balance doesn't count
        if (delegates[account] != address(0)) {
            return delegatedVotes[account];
        }

        return ownBalance + delegatedVotes[account];
    }

    // ============ Execution ============

    /// @notice Execute a passed proposal
    function executeProposal(uint256 proposalId) external nonReentrant {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.status == ProposalStatus.Active, "Not active");
        require(block.timestamp > proposal.endTime, "Voting not ended");
        require(
            block.timestamp >= proposal.endTime + EXECUTION_DELAY,
            "Execution delay not met"
        );
        require(!proposal.executed, "Already executed");

        // Check quorum
        uint256 totalVotes = proposal.forVotes + proposal.againstVotes;
        uint256 quorum = (runToken.totalSupply() * QUORUM_PERCENT) / 100;

        if (totalVotes >= quorum && proposal.forVotes > proposal.againstVotes) {
            proposal.status = ProposalStatus.Passed;
            proposal.executed = true;

            if (proposal.proposalType == ProposalType.NEW_LANDMARK) {
                LandmarkProposal memory lp = landmarkProposals[proposalId];
                approvedLandmarks[proposal.targetHash] = true;
                landmarkDetails[proposal.targetHash] = lp;

                emit LandmarkApproved(
                    proposal.targetHash,
                    lp.name,
                    lp.latitude1e6,
                    lp.longitude1e6
                );
            } else if (proposal.proposalType == ProposalType.NEW_CITY) {
                CityProposal memory cp = cityProposals[proposalId];
                approvedCities[proposal.targetHash] = true;
                cityDetails[proposal.targetHash] = cp;

                emit CityApproved(proposal.targetHash, cp.name, cp.stateHash);
            }

            emit ProposalExecuted(proposalId);
        } else {
            proposal.status = ProposalStatus.Failed;
        }
    }

    /// @notice Cancel a proposal (only proposer or owner)
    function cancelProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(
            msg.sender == proposal.proposer || msg.sender == owner(),
            "Not authorized"
        );
        require(proposal.status == ProposalStatus.Active, "Not active");

        proposal.status = ProposalStatus.Cancelled;
        emit ProposalCancelled(proposalId);
    }

    // ============ View Functions ============

    /// @notice Get proposal details
    function getProposal(uint256 proposalId) external view returns (Proposal memory) {
        return proposals[proposalId];
    }

    /// @notice Get landmark proposal details
    function getLandmarkProposal(uint256 proposalId) external view returns (LandmarkProposal memory) {
        return landmarkProposals[proposalId];
    }

    /// @notice Get city proposal details
    function getCityProposal(uint256 proposalId) external view returns (CityProposal memory) {
        return cityProposals[proposalId];
    }

    /// @notice Check if landmark is approved
    function isLandmarkApproved(bytes32 landmarkHash) external view returns (bool) {
        return approvedLandmarks[landmarkHash];
    }

    /// @notice Check if city is approved
    function isCityApproved(bytes32 cityHash) external view returns (bool) {
        return approvedCities[cityHash];
    }

    /// @notice Get approved landmark details
    function getApprovedLandmark(bytes32 landmarkHash) external view returns (LandmarkProposal memory) {
        require(approvedLandmarks[landmarkHash], "Not approved");
        return landmarkDetails[landmarkHash];
    }

    /// @notice Get approved city details
    function getApprovedCity(bytes32 cityHash) external view returns (CityProposal memory) {
        require(approvedCities[cityHash], "Not approved");
        return cityDetails[cityHash];
    }

    /// @notice Get active proposals
    function getActiveProposals(uint256 offset, uint256 limit) external view returns (uint256[] memory) {
        uint256 count = 0;
        uint256[] memory temp = new uint256[](proposalCount);

        for (uint256 i = 1; i <= proposalCount; i++) {
            if (proposals[i].status == ProposalStatus.Active) {
                temp[count] = i;
                count++;
            }
        }

        uint256 end = offset + limit > count ? count : offset + limit;
        uint256 resultLength = end > offset ? end - offset : 0;
        uint256[] memory result = new uint256[](resultLength);

        for (uint256 i = 0; i < resultLength; i++) {
            result[i] = temp[offset + i];
        }

        return result;
    }

    /// @notice Get proposal vote counts
    function getProposalVotes(uint256 proposalId) external view returns (
        uint256 forVotes,
        uint256 againstVotes,
        uint256 totalVotes,
        uint256 quorumNeeded,
        bool quorumReached
    ) {
        Proposal memory p = proposals[proposalId];
        forVotes = p.forVotes;
        againstVotes = p.againstVotes;
        totalVotes = forVotes + againstVotes;
        quorumNeeded = (runToken.totalSupply() * QUORUM_PERCENT) / 100;
        quorumReached = totalVotes >= quorumNeeded;
    }

    /// @notice Check if user can propose
    function canPropose(address user) external view returns (bool, uint256 votingPower, uint256 threshold) {
        votingPower = getVotingPower(user);
        threshold = PROPOSAL_THRESHOLD;
        return (votingPower >= threshold, votingPower, threshold);
    }

    // ============ Admin ============

    /// @notice Admin can add landmarks directly (for initial setup)
    function adminAddLandmark(
        string calldata name,
        int256 latitude1e6,
        int256 longitude1e6,
        uint256 radiusMeters,
        bytes32 cityHash,
        uint256 points
    ) external onlyOwner {
        bytes32 landmarkHash = keccak256(abi.encodePacked(name, latitude1e6, longitude1e6));
        require(!approvedLandmarks[landmarkHash], "Landmark exists");

        approvedLandmarks[landmarkHash] = true;
        landmarkDetails[landmarkHash] = LandmarkProposal({
            name: name,
            latitude1e6: latitude1e6,
            longitude1e6: longitude1e6,
            radiusMeters: radiusMeters,
            cityHash: cityHash,
            points: points
        });

        emit LandmarkApproved(landmarkHash, name, latitude1e6, longitude1e6);
    }

    /// @notice Admin can add cities directly (for initial setup)
    function adminAddCity(
        string calldata name,
        bytes32 stateHash,
        int256 minLat1e6,
        int256 maxLat1e6,
        int256 minLng1e6,
        int256 maxLng1e6
    ) external onlyOwner {
        bytes32 cityHash = keccak256(abi.encodePacked(name));
        require(!approvedCities[cityHash], "City exists");

        approvedCities[cityHash] = true;
        cityDetails[cityHash] = CityProposal({
            name: name,
            stateHash: stateHash,
            minLat1e6: minLat1e6,
            maxLat1e6: maxLat1e6,
            minLng1e6: minLng1e6,
            maxLng1e6: maxLng1e6
        });

        emit CityApproved(cityHash, name, stateHash);
    }
}
