import 'package:donut_app/screens/home_page.dart';
import 'package:donut_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InicialScreen extends StatefulWidget {
  const InicialScreen({super.key});

  @override
  State<InicialScreen> createState() => _InicialScreenState();
}

class _InicialScreenState extends State<InicialScreen> {
  static bool _supabaseReady = false;

  bool _connected = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    setState(() {
      _connected = false;
      _error = null;
    });

    try {
      if (!_supabaseReady) {
        await Supabase.initialize(
          url: dotenv.env['SUPABASE_URL']!,
          publishableKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY']!,
        );
        _supabaseReady = true;
      }

      await Supabase.instance.client
          .from('products')
          .select('id')
          .limit(1)
          .timeout(const Duration(seconds: 8));

      if (!mounted) return;
      setState(() => _connected = true);

      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      _goNext();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  void _goNext() {
    final session = Supabase.instance.client.auth.currentSession;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => session != null ? const HomePage() : const Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, color: Colors.redAccent, size: 64),
          const SizedBox(height: 16),
          const Text(
            'No se pudo conectar a Supabase',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _connect,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text(
              'Reintentar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: _supabaseReady
                ? _goNext
                : () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                  ),
            child: const Text(
              'Continuar sin conexión',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      );
    }

    if (_connected) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_done, color: Colors.greenAccent, size: 64),
          SizedBox(height: 16),
          Text(
            'Conectado a Supabase',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      );
    }

    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: Colors.pink),
        SizedBox(height: 16),
        Text(
          'Conectando con Supabase...',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }
}
