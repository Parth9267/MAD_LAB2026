import 'package:flutter/material.dart';

void main() => runApp(const PremiumApp());

class PremiumApp extends StatefulWidget {
  const PremiumApp({super.key});

  @override
  State<PremiumApp> createState() => _PremiumAppState();
}

class _PremiumAppState extends State<PremiumApp> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nova Wallet',
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        useMaterial3: true,
      ),
      home: MainDashboard(
        isDark: _isDark,
        onToggleTheme: (v) => setState(() => _isDark = v),
      ),
    );
  }
}

class MainDashboard extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onToggleTheme;

  const MainDashboard({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _navIndex = 0;
  double _balance = 12480.50;
  String _selectedCat = 'All';
  final List<String> _cats = ['All', 'Crypto', 'Stocks', 'NFTs'];

  final List<Map<String, dynamic>> _assets = [
    {
      'name': 'Bitcoin',
      'symbol': 'BTC',
      'val': '\$64,230.00',
      'change': '+4.2%',
      'up': true,
      'icon': Icons.currency_bitcoin,
      'color': Colors.orange,
    },
    {
      'name': 'Ethereum',
      'symbol': 'ETH',
      'val': '\$3,450.20',
      'change': '+2.8%',
      'up': true,
      'icon': Icons.token,
      'color': Colors.deepPurple,
    },
    {
      'name': 'Solana',
      'symbol': 'SOL',
      'val': '\$145.80',
      'change': '-1.4%',
      'up': false,
      'icon': Icons.flash_on,
      'color': Colors.teal,
    },
  ];

  void _toast(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nova Portfolio',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.onToggleTheme(!isDark),
          ),
          Badge(
            label: const Text('2'),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => _toast('2 Notifications'),
            ),
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF6366F1),
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(
                'Parth Rodrigues',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text('parth@novawallet.io'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF6366F1),
                  size: 32,
                ),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.space_dashboard_rounded),
              title: const Text('Overview'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.show_chart_rounded),
              title: const Text('Markets'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz_rounded),
              title: const Text('Transactions'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_rounded),
              title: const Text('Dark Mode'),
              value: widget.isDark,
              onChanged: (v) {
                Navigator.pop(context);
                widget.onToggleTheme(v);
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input
            TextField(
              decoration: InputDecoration(
                hintText: 'Search assets, tokens, markets...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hero Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Net Worth',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981)
                              .withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '+14.2%',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${_balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _balance += 250.0);
                            _toast('Deposit successful (+\$250)');
                          },
                          icon: const Icon(
                            Icons.arrow_downward_rounded,
                            size: 18,
                          ),
                          label: const Text('Deposit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF4F46E5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (_balance >= 100)
                              setState(() => _balance -= 100.0);
                            _toast('Transfer completed (-\$100)');
                          },
                          icon: const Icon(
                            Icons.arrow_upward_rounded,
                            size: 18,
                          ),
                          label: const Text('Send'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Category Selector Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Assets',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _toast('See all assets'),
                  child: const Text('See All'),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: _cats.map((cat) {
                final sel = _selectedCat == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: sel,
                  onSelected: (s) => setState(() => _selectedCat = cat),
                  selectedColor: theme.colorScheme.primaryContainer,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Assets List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _assets.length,
              itemBuilder: (ctx, i) {
                final item = _assets[i];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isDark
                          ? Colors.white10
                          : Colors.grey.withValues(alpha: 0.15),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: (item['color'] as Color).withValues(
                        alpha: 0.15,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: item['color'] as Color,
                      ),
                    ),
                    title: Text(
                      item['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      item['symbol'] as String,
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item['val'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          item['change'] as String,
                          style: TextStyle(
                            color: item['up'] as bool
                                ? Colors.green
                                : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _toast('Quick Trade Executed'),
        icon: const Icon(Icons.swap_calls_rounded),
        label: const Text('Quick Trade'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wallet_outlined),
            selectedIcon: Icon(Icons.wallet_rounded),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Markets',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz_rounded),
            label: 'Trade',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
