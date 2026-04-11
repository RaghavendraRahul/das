import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/today/models/catalog_model.dart';
import 'package:project_pm/src/features/today/services/catalog_service.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';

/// Modal for adding new activity templates
/// Connects to backend catalog API
class AddActivityTemplateModal extends HookConsumerWidget {
  final List<String> existingCategories;

  const AddActivityTemplateModal({
    super.key,
    required this.existingCategories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final newCategoryController = useTextEditingController();
    final duration = useState(60);
    final selectedCategory = useState(
        existingCategories.isNotEmpty ? existingCategories.first : 'COURSE');
    final isNewCategory = useState(false);
    final isSubmitting = useState(false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final catalogService = ref.read(catalogServiceProvider);

    Future<void> handleSubmit() async {
      if (isSubmitting.value) return;

      if (!(formKey.currentState?.validate() ?? false)) {
        return;
      }

      final name = nameController.text.trim();
      final finalCategory = isNewCategory.value
          ? newCategoryController.text.trim().toUpperCase()
          : selectedCategory.value;

      if (name.isEmpty || finalCategory.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      isSubmitting.value = true;

      try {
        debugPrint('Creating catalog: $name ($finalCategory)');

        final request = CreateCatalogRequest(
          name: name,
          description: descriptionController.text.trim(),
          catalogType: finalCategory,
          isActive: true,
        );

        final createdCatalog = await catalogService.createCatalog(request);
        debugPrint('Catalog created successfully: ${createdCatalog.id}');

        // Invalidate the provider to refresh the list
        ref.invalidate(apiCatalogProvider);

        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Template "$name" created successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error creating catalog: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } finally {
        if (context.mounted) {
          isSubmitting.value = false;
        }
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Icon(Icons.create_new_folder, color: Colors.blue.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'New Activity Template',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Activity Name
                      _buildLabel('Activity Name', isDark),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: nameController,
                        decoration:
                            _inputDecoration('e.g. Yoga Session', isDark),
                        style: const TextStyle(fontSize: 14),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Description
                      _buildLabel('Description', isDark),
                      const SizedBox(height: 4),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            _inputDecoration('Short description...', isDark),
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Category
                      _buildLabel('Category', isDark),
                      const SizedBox(height: 4),
                      if (!isNewCategory.value)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey.shade900
                                      : Colors.grey.shade50,
                                  border: Border.all(
                                      color: isDark
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedCategory.value,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  dropdownColor: isDark
                                      ? Colors.grey.shade800
                                      : Colors.white,
                                  items: existingCategories.map((cat) {
                                    return DropdownMenuItem(
                                        value: cat, child: Text(cat));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      selectedCategory.value = val;
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () => isNewCategory.value = true,
                              child: const Text('+ New'),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: newCategoryController,
                                autofocus: true,
                                decoration: _inputDecoration(
                                    'New Category Name', isDark),
                                style: const TextStyle(fontSize: 14),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Category is required'
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () => isNewCategory.value = false,
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Duration Slider
                      Row(
                        children: [
                          _buildLabel('Default Duration:', isDark),
                          const SizedBox(width: 8),
                          Text(
                            '${duration.value ~/ 60}h ${duration.value % 60}m',
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: duration.value.toDouble(),
                        min: 15,
                        max: 240,
                        divisions: 15,
                        onChanged: (val) => duration.value = val.round(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSubmitting.value
                        ? null
                        : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isSubmitting.value ? null : handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: isSubmitting.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Submit Template'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
    );
  }
}
