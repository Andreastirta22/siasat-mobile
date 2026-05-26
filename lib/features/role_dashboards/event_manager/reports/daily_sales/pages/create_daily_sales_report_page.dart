// daily_sales/pages/create_daily_sales_report_page.dart

import 'package:flutter/material.dart';

import '../services/daily_sales_report_service.dart';

import '../widgets/sales_quantity_card.dart';
import '../widgets/sales_summary_card.dart';

class CreateDailySalesReportPage extends StatefulWidget {
  const CreateDailySalesReportPage({super.key});

  @override
  State<CreateDailySalesReportPage> createState() =>
      _CreateDailySalesReportPageState();
}

class _CreateDailySalesReportPageState
    extends State<CreateDailySalesReportPage> {
  int ticketQty = 0;
  int insuranceQty = 0;

  double ticketPrice = 176000;
  double insurancePrice = 5150;

  bool isLoading = false;

  double get grossSales {
    return (ticketQty * ticketPrice) + (insuranceQty * insurancePrice);
  }

  Future<void> submitReport() async {
    if (ticketQty == 0 && insuranceQty == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal harus ada penjualan')),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await DailySalesReportService.createReport(
        ticketQty: ticketQty,
        insuranceQty: insuranceQty,
        ticketPrice: ticketPrice,
        insurancePrice: insurancePrice,
        grossSales: grossSales,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Report berhasil dibuat')));

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal submit report: $e')));
    } finally {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Daily Report')),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          SalesQuantityCard(
            title: 'Ticket',
            quantity: ticketQty,

            onAdd: () {
              setState(() {
                ticketQty++;
              });
            },

            onRemove: () {
              if (ticketQty == 0) return;

              setState(() {
                ticketQty--;
              });
            },
          ),

          const SizedBox(height: 16),

          SalesQuantityCard(
            title: 'Insurance',
            quantity: insuranceQty,

            onAdd: () {
              setState(() {
                insuranceQty++;
              });
            },

            onRemove: () {
              if (insuranceQty == 0) return;

              setState(() {
                insuranceQty--;
              });
            },
          ),

          const SizedBox(height: 24),

          SalesSummaryCard(grossSales: grossSales),

          const SizedBox(height: 24),

          SizedBox(
            height: 56,

            child: ElevatedButton(
              onPressed: isLoading ? null : submitReport,

              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,

                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Submit Report'),
            ),
          ),
        ],
      ),
    );
  }
}
