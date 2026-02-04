import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/constants/app_strings.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Role"),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 360;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🔵 App Icon
                    CircleAvatar(
                      radius: isSmallScreen ? 32 : 40,
                      backgroundColor:
                      colorScheme.primary.withOpacity(0.12),
                      child: Icon(
                        Icons.note_alt_outlined,
                        size: isSmallScreen ? 32 : 40,
                        color: colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 📝 Title
                    FittedBox(
                      child: Text(
                        "Notes App",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // 📄 Subtitle
                    Text(
                      "Role based access for better control",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color
                            ?.withOpacity(0.7),
                        fontSize: isSmallScreen ? 13 : 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ℹ️ Instruction
                    Text(
                      "Please select how you want to continue",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: isSmallScreen ? 14 : 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 👑 Admin Button
                    _roleButton(
                      context,
                      title: "Login as Admin",
                      color: Colors.deepPurple,
                      onTap: () {
                        context
                            .read<AuthBloc>()
                            .add(SelectRoleEvent(AppStrings.admin));
                      },
                    ),

                    const SizedBox(height: 16),

                    // 👤 User Button
                    _roleButton(
                      context,
                      title: "Login as User",
                      color: colorScheme.primary,
                      onTap: () {
                        context
                            .read<AuthBloc>()
                            .add(SelectRoleEvent(AppStrings.user));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ===============================
  // ROLE BUTTON
  // ===============================
  Widget _roleButton(
      BuildContext context, {
        required String title,
        required Color color,
        required VoidCallback onTap,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: FittedBox(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
