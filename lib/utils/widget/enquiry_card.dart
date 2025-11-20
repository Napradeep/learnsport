
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';
import '../../screens/common_provider/contact_provider.dart';

Widget enquiryCard(
  Map<String, dynamic> c, {
  required bool isAdmin,
  VoidCallback? onReply,
}) {
  final name = c["name"] ?? "Unknown";
  final message = c["message"] ?? "";
  final reply = c["reply"];
  final replyStatus = c["reply_status"] ?? "PENDING";
  final contactType = c["contact_type"] ?? "General";

  bool unread = isAdmin
      ? c["admin_read_status"] == "UNREAD"
      : c["user_read_status"] == "UNREAD";

  return StatefulBuilder(
    builder: (context, setState) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ExpansionTile(
          initiallyExpanded: false,

          onExpansionChanged: (expanded) async {
            if (expanded && unread == false) {}
          },

          leading: CircleAvatar(
            backgroundColor: AppColors.bluePrimaryDual.withOpacity(0.15),
            child: Text(
              (name.isNotEmpty ? name[0] : "?").toUpperCase(),
              style: TextStyle(
                color: AppColors.bluePrimaryDual,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          title: Text(
            contactType,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          subtitle: Text(
            name,
            style: TextStyle(color: AppColors.iconLightColor),
          ),

          trailing: isAdmin
              ? InkWell(
                  onTap: () {
                    if (!unread) {
                      setState(() {});
                      return;
                    }

                    CustomConfirmationDialog.show(
                      context: context,
                      title: "Mark as Read!",
                      message: "Do you want to mark this enquiry as read?",
                      icon: Icons.mark_email_read_outlined,
                      iconColor: Colors.green,
                      confirmColor: Colors.green,
                      onConfirm: () async {
                        final provider = Provider.of<ContactProvider>(
                            context,
                            listen: false);

                        bool success = isAdmin
                            ? await provider.markAdminRead(c["_id"])
                            : await provider.markUserRead(c["_id"]);

                        if (success) {
                          unread = false;

                          setState(() {
                            if (isAdmin) {
                              c["admin_read_status"] = "READ";
                            } else {
                              c["user_read_status"] = "READ";
                            }
                          });

                          await Future.delayed(
                              const Duration(milliseconds: 150));
                          setState(() {});
                        }
                      },
                    );
                  },
                  child: Chip(
                    label: Text(
                      unread ? "Unread" : "Read",
                      style: TextStyle(
                        color:
                            unread ? Colors.orange.shade800 : Colors.green,
                      ),
                    ),
                    backgroundColor:
                        unread ? Colors.orange.shade100 : Colors.green.shade100,
                  ),
                )
              : const SizedBox(),

          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "User Message:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),

                  /// ✅ FIXED — LEFT ALIGNED USER MESSAGE
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      message,
                      textAlign: TextAlign.start,
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (reply != null && reply.toString().trim().isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bluePrimaryDual.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Admin Reply:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),

                          
                          Text(
                            reply.toString(),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),

                  if (isAdmin && replyStatus == "PENDING") ...[
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: onReply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bluePrimaryDual,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Reply"),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

