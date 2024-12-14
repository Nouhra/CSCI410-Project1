// Student name: Joseph Nouhra.
// Student Id: 52131020.
import 'package:flutter/material.dart';

void main() {
  runApp( MenuApp());
}

class MenuApp extends StatelessWidget {
  const MenuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu App',
      home:  MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<String> _Items = ["Burger - \$5", "Pizza - \$10", "Pasta - \$8", "Salad - \$4"];
  final Map<String, double> _Price = {
    "Burger": 5.0,
    "Pizza": 10.0,
    "Pasta": 8.0,
    "Salad": 4.0,
  };
  final List<String> _sauces = ["Ketchup - \$0.5", "Garlic Sauce - \$1", "BBQ Sauce - \$1.5", "Cheese Sauce - \$2"];
  final Map<String, double> _saucePrices = {
    "Ketchup": 0.5,
    "Garlic Sauce": 1.0,
    "BBQ Sauce": 1.5,
    "Cheese Sauce": 2.0,
  };

  String _selecteItem = "";
  String _selecteSauce = "";
  double _totalPrice = 0.0;
  final List<String> _cart = [];
  String _message = "";
  bool _usd = true;

  static const double _Lira = 90000.0;

  void _addToCart() {
    setState(() {
      if (_selecteItem.isNotEmpty) {
        String cartEntry = _selecteItem;
        double itemPrice = _Price[_selecteItem]!;

        // Add sauce price if selected
        if (_selecteSauce.isNotEmpty) {
          cartEntry += " with $_selecteSauce";
          itemPrice += _saucePrices[_selecteSauce.split(' - ')[0]] ?? 0.0;
        }

        if (!_usd) {
          itemPrice *= _Lira;
          cartEntry += " (LL ${itemPrice.toStringAsFixed(0)})";
        } else {
          cartEntry += " (\$${itemPrice.toStringAsFixed(2)})";
        }

        _cart.add(cartEntry);

        // Reset selection after adding to cart
        _selecteItem = "";
        _selecteSauce = "";
        _totalPrice = 0.0;
        _message = "Order Completed: Item added to the cart.";
      } else {
        _message = "Please select an item before adding to the cart.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Center(
            child: const Text(
              'Choose your meal:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _Items.length,
              itemBuilder: (context, index) {
                String item = _Items[index];
                String itemName = item.split(' - ')[0];
                return RadioListTile<String>(
                  title: Text(item),
                  value: itemName,
                  groupValue: _selecteItem,
                  onChanged: (value) {
                    setState(() {
                      _selecteItem = value!;
                      _totalPrice = _Price[_selecteItem]!;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Choose a sauce (optional):',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: _selecteSauce.isEmpty ? null : _selecteSauce,
            hint: const Text('Select a sauce'),
            items: _sauces.map((sauce) {
              return DropdownMenuItem<String>(
                value: sauce,
                child: Text(sauce),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selecteSauce = value!;
                _totalPrice = _Price[_selecteItem]!;
                _totalPrice += _saucePrices[_selecteSauce.split(' - ')[0]] ?? 0.0;
              });
            },
          ),
          const SizedBox(height: 10),
          if (_selecteItem.isNotEmpty)
            Text(
              'You selected: $_selecteItem${_selecteSauce.isNotEmpty ? " with $_selecteSauce" : ""}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          const SizedBox(height: 10),
          // Currency Checkboxes
          Row(
            children: [
              const Text(
                'Currency:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Checkbox(
                value: _usd,
                onChanged: (value) {
                  setState(() {
                    _usd = true;
                  });
                },
              ),
              const Text("\$ USD"),
              Checkbox(
                value: !_usd,
                onChanged: (value) {
                  setState(() {
                    _usd = false;
                  });
                },
              ),
              const Text("LL"),
            ],
          ),
          const SizedBox(height: 10), // Added SizedBox after the last checkbox
          // Total Price Display
          if (_totalPrice > 0)
            Text(
              'Total Price: ${_usd ? "\$${_totalPrice.toStringAsFixed(2)}" : "LL ${( _totalPrice * _Lira).toStringAsFixed(0)}"}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              _message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: _addToCart,
            child: const Text('Add to Cart'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Shopping Cart:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_cart[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
