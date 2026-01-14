import 'package:flutter/material.dart';
import '../services/blockchain_service.dart';

/// Dialog for showing blockchain transaction progress
class TransactionDialog extends StatefulWidget {
  final Future<String?> transactionFuture;
  final String title;
  final String? successMessage;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;

  const TransactionDialog({
    super.key,
    required this.transactionFuture,
    this.title = 'Processing Transaction',
    this.successMessage,
    this.onSuccess,
    this.onFailure,
  });

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();

  /// Show transaction dialog and handle result
  static Future<void> show({
    required BuildContext context,
    required Future<String?> transactionFuture,
    String title = 'Processing Transaction',
    String? successMessage,
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TransactionDialog(
        transactionFuture: transactionFuture,
        title: title,
        successMessage: successMessage,
        onSuccess: onSuccess,
        onFailure: onFailure,
      ),
    );
  }
}

class _TransactionDialogState extends State<TransactionDialog> {
  String _status = 'Preparing transaction...';
  bool _isLoading = true;
  bool _isSuccess = false;
  bool _isError = false;
  String? _txHash;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _executeTransaction();
  }

  Future<void> _executeTransaction() async {
    try {
      setState(() {
        _status = 'Estimating gas...';
      });

      final txHash = await widget.transactionFuture;

      if (txHash != null && mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
          _txHash = txHash;
          _status = 'Transaction submitted!';
        });

        // Wait a bit before closing
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          widget.onSuccess?.call();
          Navigator.of(context).pop();
          
          // Show success snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.successMessage ?? 'Transaction successful!',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        throw Exception('Transaction returned null');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _errorMessage = e.toString().length > 100
              ? e.toString().substring(0, 100)
              : e.toString();
          _status = 'Transaction failed';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_isLoading, // Prevent closing during loading
      child: AlertDialog(
        title: Row(
          children: [
            if (_isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (_isSuccess)
              const Icon(Icons.check_circle, color: Colors.green, size: 20)
            else if (_isError)
              const Icon(Icons.error, color: Colors.red, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(widget.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_status),
            if (_isLoading) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            if (_isSuccess && _txHash != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction Hash:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      _txHash!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_isError && _errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (_isError) ...[
            TextButton(
              onPressed: () {
                widget.onFailure?.call();
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _executeTransaction();
              },
              child: const Text('Retry'),
            ),
          ] else if (_isSuccess) ...[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ],
      ),
    );
  }
}
