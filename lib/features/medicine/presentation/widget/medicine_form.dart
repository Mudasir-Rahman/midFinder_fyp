//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';
// import 'package:rx_locator/features/medicine/data/model/medicine_model.dart';
//
// // 🎨 PREMIUM COLOR PALETTE
// const Color kPrimaryDark = Color(0xFF1A237E);
// const Color kPrimaryLight = Color(0xFF3949AB);
// const Color kAccentGreen = Color(0xFF00C853);
// const Color kAccentOrange = Color(0xFFFF6F00);
// const Color kCardBackground = Colors.white;
// const double kCardRadius = 20.0;
// const double kInputRadius = 12.0;
//
// class MedicineForm extends StatefulWidget {
//   final GlobalKey<FormState> formKey;
//   final Function(MedicineEntity, {XFile? imageFile}) onSubmit;
//   final MedicineEntity? medicine;
//   final String pharmacyId;
//
//   const MedicineForm({
//     super.key,
//     required this.formKey,
//     required this.onSubmit,
//     this.medicine,
//     required this.pharmacyId,
//   });
//
//   @override
//   State<MedicineForm> createState() => _MedicineFormState();
// }
//
// class _MedicineFormState extends State<MedicineForm> {
//   // --- Controllers ---
//   final _medicineNameController = TextEditingController();
//   final _genericNameController = TextEditingController();
//   final _dosageController = TextEditingController();
//   final _manufacturerController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _categoryController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _stockQuantityController = TextEditingController();
//
//   // --- Saved Data ---
//   String _savedMedicineName = '';
//   String _savedGenericName = '';
//   String _savedDosage = '';
//   String _savedManufacturer = '';
//   String _savedDescription = '';
//   String _savedCategory = '';
//   double? _savedPrice;
//   int _savedStockQuantity = 0;
//
//   bool _requiresPrescription = false;
//   bool _isAvailable = true;
//
//   // --- Image Upload Variables ---
//   final ImagePicker _imagePicker = ImagePicker();
//   XFile? _selectedImage;
//   String? _imageUrl;
//   bool _isUploadingImage = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.medicine != null) {
//       _medicineNameController.text = widget.medicine!.medicineName;
//       _genericNameController.text = widget.medicine!.genericName;
//       _dosageController.text = widget.medicine!.dosage;
//       _manufacturerController.text = widget.medicine!.manufacturer;
//       _descriptionController.text = widget.medicine!.description;
//       _categoryController.text = widget.medicine!.category;
//       _priceController.text = widget.medicine!.price?.toStringAsFixed(2) ?? '';
//       _stockQuantityController.text =
//           widget.medicine!.stockQuantity?.toString() ?? '0';
//       _requiresPrescription = widget.medicine!.requiresPrescription ?? false;
//       _isAvailable = widget.medicine!.isAvailable ?? true;
//       _imageUrl = widget.medicine!.imageUrl;
//
//       _savedMedicineName = widget.medicine!.medicineName;
//       _savedGenericName = widget.medicine!.genericName;
//       _savedDosage = widget.medicine!.dosage;
//       _savedManufacturer = widget.medicine!.manufacturer;
//       _savedDescription = widget.medicine!.description;
//       _savedCategory = widget.medicine!.category;
//       _savedPrice = widget.medicine!.price;
//       _savedStockQuantity = widget.medicine!.stockQuantity ?? 0;
//     }
//   }
//
//   // --- Image Methods ---
//   Future<void> _pickImageFromGallery() async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 800,
//         maxHeight: 800,
//         imageQuality: 80,
//       );
//       if (image != null) {
//         setState(() {
//           _selectedImage = image;
//           _imageUrl = null;
//         });
//       }
//     } catch (e) {
//       _showErrorSnackBar('Failed to pick image: $e');
//     }
//   }
//
//   Future<void> _takePhotoWithCamera() async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 800,
//         maxHeight: 800,
//         imageQuality: 80,
//       );
//       if (image != null) {
//         setState(() {
//           _selectedImage = image;
//           _imageUrl = null;
//         });
//       }
//     } catch (e) {
//       _showErrorSnackBar('Failed to take photo: $e');
//     }
//   }
//
//   void _removeImage() {
//     setState(() {
//       _selectedImage = null;
//       _imageUrl = null;
//     });
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }
//
//   // --- Form Submission ---
//   void _handleSaveAndSubmit() {
//     if (widget.formKey.currentState!.validate()) {
//       widget.formKey.currentState!.save();
//
//       final medicine = MedicineModel(
//         id: widget.medicine?.id ?? '',
//         pharmacyId: widget.medicine?.pharmacyId ?? widget.pharmacyId,
//         medicineName: _savedMedicineName,
//         genericName: _savedGenericName,
//         dosage: _savedDosage,
//         manufacturer: _savedManufacturer,
//         description: _savedDescription,
//         category: _savedCategory,
//         createdAt: widget.medicine?.createdAt ?? DateTime.now(),
//         imageUrl: _imageUrl,
//         price: _savedPrice,
//         stockQuantity: _savedStockQuantity,
//         isAvailable: _isAvailable,
//         requiresPrescription: _requiresPrescription,
//       );
//
//       widget.onSubmit(medicine, imageFile: _selectedImage);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('✅ Medicine saved successfully!'),
//           backgroundColor: kAccentGreen,
//         ),
//       );
//     }
//   }
//
//   // --- Widgets ---
//   Widget _buildImageUploadSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Medicine Image',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kPrimaryDark),
//         ),
//         const SizedBox(height: 8),
//         Text('Add a clear image of the medicine packaging',
//             style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//         const SizedBox(height: 16),
//         Container(
//           width: double.infinity,
//           height: 200,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(kInputRadius),
//             color: Colors.grey.shade50,
//           ),
//           child: _isUploadingImage
//               ? const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(color: kAccentGreen),
//                 SizedBox(height: 8),
//                 Text('Uploading image...'),
//               ],
//             ),
//           )
//               : _selectedImage != null || _imageUrl != null
//               ? Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(kInputRadius),
//                 child: _selectedImage != null
//                     ? Image.file(File(_selectedImage!.path),
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.cover)
//                     : Image.network(
//                   _imageUrl!,
//                   width: double.infinity,
//                   height: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) =>
//                       _buildImagePlaceholder(),
//                 ),
//               ),
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.close, color: Colors.white, size: 20),
//                     onPressed: _removeImage,
//                   ),
//                 ),
//               ),
//             ],
//           )
//               : _buildImagePlaceholder(),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: OutlinedButton.icon(
//                 icon: const Icon(Icons.photo_library, size: 20),
//                 label: const Text('Gallery'),
//                 onPressed: _pickImageFromGallery,
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: kPrimaryLight,
//                   side: BorderSide(color: kPrimaryLight),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: OutlinedButton.icon(
//                 icon: const Icon(Icons.camera_alt, size: 20),
//                 label: const Text('Camera'),
//                 onPressed: _takePhotoWithCamera,
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: kPrimaryLight,
//                   side: BorderSide(color: kPrimaryLight),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildImagePlaceholder() {
//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.photo_camera_back, size: 50, color: Colors.grey),
//         SizedBox(height: 8),
//         Text('No image selected', style: TextStyle(color: Colors.grey)),
//       ],
//     );
//   }
//
//   Widget _buildSection({required String title, required List<Widget> children}) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
//       margin: const EdgeInsets.only(bottom: 25.0),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           _buildSectionHeader(title),
//           const SizedBox(height: 18),
//           ...children,
//         ]),
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title) {
//     return Row(
//       children: [
//         Container(
//           width: 5,
//           height: 25,
//           decoration: BoxDecoration(
//             color: kAccentGreen,
//             borderRadius: BorderRadius.circular(2),
//           ),
//           margin: const EdgeInsets.only(right: 8),
//         ),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w900,
//             color: kPrimaryDark,
//             letterSpacing: 0.2,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String labelText,
//     IconData? icon,
//     int maxLines = 1,
//     TextInputType keyboardType = TextInputType.text,
//     String? hintText,
//     String? Function(String?)? validator,
//     required void Function(String) onSaved,
//   }) {
//     return TextFormField(
//       controller: controller,
//       maxLines: maxLines,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         labelText: labelText,
//         hintText: hintText,
//         floatingLabelStyle:
//         const TextStyle(color: kPrimaryLight, fontWeight: FontWeight.bold),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(kInputRadius),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(kInputRadius),
//           borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(kInputRadius),
//           borderSide: const BorderSide(color: kAccentGreen, width: 2.0),
//         ),
//         filled: true,
//         fillColor: Colors.grey.shade50,
//         prefixIcon: icon != null ? Icon(icon, color: kPrimaryLight) : null,
//         contentPadding:
//         const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
//         alignLabelWithHint: maxLines > 1,
//       ),
//       validator: validator,
//       onSaved: (value) => onSaved(value ?? ''),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Form(
//         key: widget.formKey,
//         onWillPop: () async => true,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSection(title: 'Medicine Image', children: [_buildImageUploadSection()]),
//             _buildSection(title: 'Basic Medicine Details', children: [
//               _buildTextFormField(
//                 controller: _medicineNameController,
//                 labelText: 'Medicine Name *',
//                 icon: Icons.medication_rounded,
//                 validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null,
//                 onSaved: (v) => _savedMedicineName = v,
//               ),
//               const SizedBox(height: 16),
//               _buildTextFormField(
//                 controller: _genericNameController,
//                 labelText: 'Generic Name *',
//                 icon: Icons.science_rounded,
//                 validator: (v) => (v == null || v.isEmpty) ? 'Generic name is required' : null,
//                 onSaved: (v) => _savedGenericName = v,
//               ),
//               const SizedBox(height: 16),
//               _buildTextFormField(
//                 controller: _dosageController,
//                 labelText: 'Dosage (e.g., 500mg, 10ml) *',
//                 icon: Icons.format_size_rounded,
//                 validator: (v) => (v == null || v.isEmpty) ? 'Dosage is required' : null,
//                 onSaved: (v) => _savedDosage = v,
//               ),
//               const SizedBox(height: 16),
//               _buildTextFormField(
//                 controller: _manufacturerController,
//                 labelText: 'Manufacturer *',
//                 icon: Icons.business_rounded,
//                 validator: (v) => (v == null || v.isEmpty) ? 'Manufacturer is required' : null,
//                 onSaved: (v) => _savedManufacturer = v,
//               ),
//               const SizedBox(height: 16),
//               _buildTextFormField(
//                 controller: _categoryController,
//                 labelText: 'Category (e.g., Analgesic, Antibiotic) *',
//                 icon: Icons.category_rounded,
//                 validator: (v) => (v == null || v.isEmpty) ? 'Category is required' : null,
//                 onSaved: (v) => _savedCategory = v,
//               ),
//               const SizedBox(height: 16),
//               _buildTextFormField(
//                 controller: _descriptionController,
//                 labelText: 'Description / Usage Instructions *',
//                 icon: Icons.description_rounded,
//                 maxLines: 4,
//                 validator: (v) => (v == null || v.isEmpty) ? 'Description is required' : null,
//                 onSaved: (v) => _savedDescription = v,
//               ),
//             ]),
//             _buildSection(title: 'Pricing & Inventory', children: [
//               Row(children: [
//                 Expanded(
//                   child: _buildTextFormField(
//                     controller: _priceController,
//                     labelText: 'Unit Price (\$)',
//                     icon: Icons.attach_money_rounded,
//                     keyboardType:
//                     const TextInputType.numberWithOptions(decimal: true),
//                     hintText: '0.00',
//                     validator: (v) {
//                       if (v != null && v.isNotEmpty) {
//                         final price = double.tryParse(v);
//                         if (price == null || price < 0) return 'Invalid price';
//                       }
//                       return null;
//                     },
//                     onSaved: (v) =>
//                     _savedPrice = v.isNotEmpty ? double.tryParse(v) : null,
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: _buildTextFormField(
//                     controller: _stockQuantityController,
//                     labelText: 'Stock Quantity *',
//                     icon: Icons.inventory_rounded,
//                     keyboardType: TextInputType.number,
//                     hintText: '0',
//                     validator: (v) {
//                       if (v == null || v.isEmpty) return 'Stock is required';
//                       final quantity = int.tryParse(v);
//                       if (quantity == null || quantity < 0) return 'Invalid quantity';
//                       return null;
//                     },
//                     onSaved: (v) => _savedStockQuantity = int.tryParse(v) ?? 0,
//                   ),
//                 ),
//               ]),
//             ]),
//             _buildSection(title: 'Availability', children: [
//               SwitchListTile(
//                 title: const Text('Requires Prescription',
//                     style: TextStyle(fontWeight: FontWeight.w700, color: kPrimaryDark)),
//                 subtitle: const Text('Only dispenses with a valid doctor\'s prescription'),
//                 value: _requiresPrescription,
//                 activeColor: kAccentGreen,
//                 onChanged: (v) => setState(() => _requiresPrescription = v),
//                 secondary: const Icon(Icons.medical_services_rounded, color: kPrimaryLight),
//               ),
//               const SizedBox(height: 10),
//               SwitchListTile(
//                 title: const Text('Available for Sale',
//                     style: TextStyle(fontWeight: FontWeight.w700, color: kPrimaryDark)),
//                 subtitle: const Text('Toggle to make this medicine visible and purchasable'),
//                 value: _isAvailable,
//                 activeColor: kAccentGreen,
//                 onChanged: (v) => setState(() => _isAvailable = v),
//                 secondary: Icon(
//                   _isAvailable
//                       ? Icons.shopping_cart_rounded
//                       : Icons.visibility_off_rounded,
//                   color: _isAvailable ? kAccentGreen : Colors.grey,
//                 ),
//               ),
//             ]),
//
//             const SizedBox(height: 30),
//
//             // ✅ Save Button
//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: _handleSaveAndSubmit,
//                 icon: const Icon(Icons.save_rounded, color: Colors.white),
//                 label: const Text(
//                   'Save Medicine',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: kAccentGreen,
//                   padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//   }}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';
import 'package:rx_locator/features/medicine/data/model/medicine_model.dart';

// 🎨 PREMIUM COLOR PALETTE
const Color kPrimaryDark = Color(0xFF1A237E);
const Color kPrimaryLight = Color(0xFF3949AB);
const Color kAccentGreen = Color(0xFF00C853);
const Color kAccentOrange = Color(0xFFFF6F00);
const Color kCardBackground = Colors.white;
const double kCardRadius = 20.0;
const double kInputRadius = 12.0;

class MedicineForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(MedicineEntity, {XFile? imageFile}) onSubmit;
  final MedicineEntity? medicine;
  final String pharmacyId;

  const MedicineForm({
    super.key,
    required this.formKey,
    required this.onSubmit,
    this.medicine,
    required this.pharmacyId,
  });

  @override
  State<MedicineForm> createState() => _MedicineFormState();
}

class _MedicineFormState extends State<MedicineForm> {
  // --- Controllers ---
  final _medicineNameController = TextEditingController();
  final _genericNameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockQuantityController = TextEditingController();

  // --- Saved Data ---
  String _savedMedicineName = '';
  String _savedGenericName = '';
  String _savedDosage = '';
  String _savedManufacturer = '';
  String _savedDescription = '';
  String _savedCategory = '';
  double? _savedPrice;
  int _savedStockQuantity = 0;

  bool _requiresPrescription = false;
  bool _isAvailable = true;

  // --- Image Upload Variables ---
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  String? _imageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    if (widget.medicine != null) {
      _medicineNameController.text = widget.medicine!.medicineName;
      _genericNameController.text = widget.medicine!.genericName;
      _dosageController.text = widget.medicine!.dosage;
      _manufacturerController.text = widget.medicine!.manufacturer;
      _descriptionController.text = widget.medicine!.description;
      _categoryController.text = widget.medicine!.category;
      _priceController.text = widget.medicine!.price?.toStringAsFixed(2) ?? '';
      _stockQuantityController.text =
          widget.medicine!.stockQuantity?.toString() ?? '0';
      _requiresPrescription = widget.medicine!.requiresPrescription ?? false;
      _isAvailable = widget.medicine!.isAvailable ?? true;
      _imageUrl = widget.medicine!.imageUrl;

      _savedMedicineName = widget.medicine!.medicineName;
      _savedGenericName = widget.medicine!.genericName;
      _savedDosage = widget.medicine!.dosage;
      _savedManufacturer = widget.medicine!.manufacturer;
      _savedDescription = widget.medicine!.description;
      _savedCategory = widget.medicine!.category;
      _savedPrice = widget.medicine!.price;
      _savedStockQuantity = widget.medicine!.stockQuantity ?? 0;
    }
  }

  // --- Image Methods ---
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _imageUrl = null;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _takePhotoWithCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _imageUrl = null;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to take photo: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageUrl = null;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kAccentGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- Form Submission ---
  void _handleSaveAndSubmit() {
    print('=== MEDICINE FORM SUBMISSION DEBUG ===');
    print('Form validated: ${widget.formKey.currentState!.validate()}');

    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();

      print('✅ Form saved successfully');
      print('Medicine Name: $_savedMedicineName');
      print('Generic Name: $_savedGenericName');
      print('Pharmacy ID: ${widget.pharmacyId}');
      print('Image Selected: ${_selectedImage != null}');
      print('Image URL: $_imageUrl');

      final medicine = MedicineModel(
        id: widget.medicine?.id ?? '',
        pharmacyId: widget.medicine?.pharmacyId ?? widget.pharmacyId,
        medicineName: _savedMedicineName,
        genericName: _savedGenericName,
        dosage: _savedDosage,
        manufacturer: _savedManufacturer,
        description: _savedDescription,
        category: _savedCategory,
        createdAt: widget.medicine?.createdAt ?? DateTime.now(),
        imageUrl: _imageUrl,
        price: _savedPrice,
        stockQuantity: _savedStockQuantity,
        isAvailable: _isAvailable,
        requiresPrescription: _requiresPrescription,
      );

      print('🚀 Calling onSubmit callback...');
      widget.onSubmit(medicine, imageFile: _selectedImage);

      _showSuccessSnackBar('✅ Medicine saved successfully!');
    } else {
      print('❌ Form validation failed');
      _showErrorSnackBar('❌ Please fix the errors in the form');
    }
  }

  // --- Widgets ---
  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medicine Image',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kPrimaryDark
          ),
        ),
        const SizedBox(height: 8),
        Text(
            'Add a clear image of the medicine packaging',
            style: TextStyle(fontSize: 14, color: Colors.grey[600])
        ),
        const SizedBox(height: 16),

        // Image Container
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(kInputRadius),
            color: Colors.grey.shade50,
          ),
          child: _buildImageContent(),
        ),
        const SizedBox(height: 16),

        // Image Action Buttons
        _buildImageActionButtons(),
      ],
    );
  }

  Widget _buildImageContent() {
    if (_isUploadingImage) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: kAccentGreen),
            SizedBox(height: 8),
            Text('Uploading image...'),
          ],
        ),
      );
    }

    if (_selectedImage != null || _imageUrl != null) {
      return Stack(
        children: [
          // Image Display
          ClipRRect(
            borderRadius: BorderRadius.circular(kInputRadius),
            child: _selectedImage != null
                ? Image.file(
              File(_selectedImage!.path),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildImagePlaceholder(),
            )
                : Image.network(
              _imageUrl!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) =>
                  _buildImagePlaceholder(),
            ),
          ),

          // Remove Image Button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: _removeImage,
              ),
            ),
          ),
        ],
      );
    }

    return _buildImagePlaceholder();
  }

  Widget _buildImageActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.photo_library, size: 20),
            label: const Text('Gallery'),
            onPressed: _pickImageFromGallery,
            style: OutlinedButton.styleFrom(
              foregroundColor: kPrimaryLight,
              side: BorderSide(color: kPrimaryLight),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.camera_alt, size: 20),
            label: const Text('Camera'),
            onPressed: _takePhotoWithCamera,
            style: OutlinedButton.styleFrom(
              foregroundColor: kPrimaryLight,
              side: BorderSide(color: kPrimaryLight),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return InkWell(
      onTap: _pickImageFromGallery,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_camera_back, size: 50, color: Colors.grey),
          SizedBox(height: 8),
          Text('Tap to add image', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    String? description,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      margin: const EdgeInsets.only(bottom: 25.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(title, description: description),
              const SizedBox(height: 18),
              ...children,
            ]
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 5,
              height: 25,
              decoration: BoxDecoration(
                color: kAccentGreen,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(right: 8),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: kPrimaryDark,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    String? Function(String?)? validator,
    required void Function(String) onSaved,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: isRequired ? '$labelText *' : labelText,
            hintText: hintText,
            floatingLabelStyle: const TextStyle(
                color: kPrimaryLight,
                fontWeight: FontWeight.bold
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputRadius),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kInputRadius),
              borderSide: const BorderSide(color: kAccentGreen, width: 2.0),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            prefixIcon: icon != null ? Icon(icon, color: kPrimaryLight) : null,
            contentPadding: const EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: 16.0
            ),
            alignLabelWithHint: maxLines > 1,
          ),
          validator: validator,
          onSaved: (value) => onSaved(value ?? ''),
        ),
        if (isRequired) ...[
          const SizedBox(height: 4),
          Text(
            '* Required field',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    Color? activeColor,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: kPrimaryDark
        ),
      ),
      subtitle: Text(subtitle),
      value: value,
      activeColor: activeColor ?? kAccentGreen,
      onChanged: onChanged,
      secondary: Icon(icon, color: kPrimaryLight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            _buildSection(
              title: 'Medicine Image',
              description: 'Upload a clear image of the medicine packaging',
              children: [
                _buildImageUploadSection(),
              ],
            ),

            // Basic Medicine Details Section
            _buildSection(
              title: 'Basic Medicine Details',
              description: 'Enter the core information about the medicine',
              children: [
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _medicineNameController,
                  labelText: 'Medicine Name',
                  icon: Icons.medication_rounded,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Medicine name is required'
                      : null,
                  onSaved: (v) => _savedMedicineName = v,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _genericNameController,
                  labelText: 'Generic Name',
                  icon: Icons.science_rounded,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Generic name is required'
                      : null,
                  onSaved: (v) => _savedGenericName = v,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _dosageController,
                  labelText: 'Dosage',
                  icon: Icons.format_size_rounded,
                  hintText: 'e.g., 500mg, 10ml',
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Dosage is required'
                      : null,
                  onSaved: (v) => _savedDosage = v,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _manufacturerController,
                  labelText: 'Manufacturer',
                  icon: Icons.business_rounded,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Manufacturer is required'
                      : null,
                  onSaved: (v) => _savedManufacturer = v,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _categoryController,
                  labelText: 'Category',
                  icon: Icons.category_rounded,
                  hintText: 'e.g., Analgesic, Antibiotic',
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Category is required'
                      : null,
                  onSaved: (v) => _savedCategory = v,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  icon: Icons.description_rounded,
                  maxLines: 4,
                  hintText: 'Enter usage instructions and description',
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Description is required'
                      : null,
                  onSaved: (v) => _savedDescription = v,
                ),
              ],
            ),

            // Pricing & Inventory Section
            _buildSection(
              title: 'Pricing & Inventory',
              description: 'Set the price and stock quantity',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTextFormField(
                        controller: _priceController,
                        labelText: 'Unit Price',
                        icon: Icons.attach_money_rounded,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        hintText: '0.00',
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final price = double.tryParse(v);
                            if (price == null || price < 0) return 'Invalid price';
                          }
                          return null;
                        },
                        onSaved: (v) => _savedPrice = v.isNotEmpty ? double.tryParse(v) : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildTextFormField(
                        controller: _stockQuantityController,
                        labelText: 'Stock Quantity',
                        icon: Icons.inventory_rounded,
                        keyboardType: TextInputType.number,
                        hintText: '0',
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Stock quantity is required';
                          final quantity = int.tryParse(v);
                          if (quantity == null || quantity < 0) return 'Invalid quantity';
                          return null;
                        },
                        onSaved: (v) => _savedStockQuantity = int.tryParse(v) ?? 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Availability Section
            _buildSection(
              title: 'Availability & Restrictions',
              description: 'Configure medicine availability and prescription requirements',
              children: [
                _buildSwitchTile(
                  title: 'Requires Prescription',
                  subtitle: 'Only dispenses with a valid doctor\'s prescription',
                  value: _requiresPrescription,
                  onChanged: (v) => setState(() => _requiresPrescription = v),
                  icon: Icons.medical_services_rounded,
                ),
                const SizedBox(height: 10),
                _buildSwitchTile(
                  title: 'Available for Sale',
                  subtitle: 'Toggle to make this medicine visible and purchasable',
                  value: _isAvailable,
                  onChanged: (v) => setState(() => _isAvailable = v),
                  icon: _isAvailable
                      ? Icons.shopping_cart_rounded
                      : Icons.visibility_off_rounded,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Save Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _handleSaveAndSubmit,
                icon: const Icon(Icons.save_rounded, color: Colors.white),
                label: const Text(
                  'Save Medicine',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _genericNameController.dispose();
    _dosageController.dispose();
    _manufacturerController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockQuantityController.dispose();
    super.dispose();
  }
}