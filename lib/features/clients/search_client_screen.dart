import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../shared/models/form_submission.dart';

class SearchClientScreen extends StatefulWidget {
  const SearchClientScreen({super.key});

  @override
  State<SearchClientScreen> createState() => _SearchClientScreenState();
}

class _SearchClientScreenState extends State<SearchClientScreen> {
  final _searchController = TextEditingController();
  final _cifController = TextEditingController();

  List<ClientSearchResult> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    _cifController.dispose();
    super.dispose();
  }

  Future<void> _searchClients() async {
    final companyName = _searchController.text.trim();
    final cif = _cifController.text.trim();

    if (companyName.isEmpty && cif.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese al menos un criterio de búsqueda'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = false;
    });

    try {
      final results = await ApiService.searchClients(
        companyName: companyName.isEmpty ? null : companyName,
        cif: cif.isEmpty ? null : cif,
      );

      setState(() {
        _searchResults = results;
        _hasSearched = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en la búsqueda: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _cifController.clear();
      _searchResults.clear();
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Buscar Cliente'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchForm(),
          const Divider(height: 1),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Criterios de Búsqueda',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // Company Name Field
          TextFormField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la Empresa',
              hintText: 'Ingrese el nombre de la empresa',
              prefixIcon: Icon(Icons.business_outlined),
            ),
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // CIF Field
          TextFormField(
            controller: _cifController,
            decoration: const InputDecoration(
              labelText: 'CIF',
              hintText: 'Ingrese el CIF de la empresa',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (_) => _searchClients(),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearSearch,
                  child: const Text('Limpiar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _searchClients,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Buscar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_hasSearched) {
      return _buildEmptyState(
        'Realizar Búsqueda',
        'Ingrese los criterios de búsqueda y presione "Buscar" para encontrar clientes.',
        Icons.search_outlined,
      );
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState(
        'Sin Resultados',
        'No se encontraron clientes que coincidan con los criterios de búsqueda.',
        Icons.search_off_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final client = _searchResults[index];
        return _buildClientCard(client);
      },
    );
  }

  Widget _buildEmptyState(String title, String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientCard(ClientSearchResult client) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => _editClient(client),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Name and CIF
              Row(
                children: [
                  Expanded(
                    child: Text(
                      client.cliente,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      client.cif,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Address
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      client.direccion,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Contact Information
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 16,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                client.personaContacto,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 16,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              client.telefonoContacto,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Created Date
              Text(
                'Creado: ${_formatDate(client.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _editClient(ClientSearchResult client) {
    print('_editClient called with client ID: ${client.id}, cliente: ${client.cliente}');
    Navigator.of(context).pushNamed(
      '/form',
      arguments: {
        'isEditMode': true,
        'clientId': client.id.toString(),
        'tipoInforme': 'FIDELIZACIÓN', // Siempre usar vista de fidelización para editar
      },
    );
  }
}