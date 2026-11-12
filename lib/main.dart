import 'package:flutter/material.dart';

void main() { runApp(const SintaApp()); }

const Color maroon = Color(0xFF811D22);
const Color brown = Color(0xFF5D3027);
const Color cream = Color(0xFFFFF6EA);
const Color beige = Color(0xFFF3E0C8);
const Color dark = Color(0xFF342620);
const int deliveryFee = 80;

String peso(int amount) {
  String text = amount.toString();
  if (text.length > 3) {
    text = '${text.substring(0, text.length - 3)},${text.substring(text.length - 3)}';
  }
  return '₱$text';
}

// OOP pillar 1: ABSTRACTION. All items follow the same structure.
abstract class LocalProduct {
  final int id;
  final String name;
  final String category;
  final String description;
  final String image;
  final int price;
  final List<String> options;
  int stock;
  LocalProduct(this.id, this.name, this.category, this.description,
      this.image, this.price, this.options, this.stock);
  String get originStory;
}

// OOP pillars 2 and 3: INHERITANCE and POLYMORPHISM.
class Souvenir extends LocalProduct {
  Souvenir(int id, String name, String description, String image, int price,
      List<String> options, int stock)
      : super(id, name, 'Souvenirs', description, image, price, options, stock);
  @override
  String get originStory => 'Inspired by traditional Filipino games and keepsakes.';
}
class WovenProduct extends LocalProduct {
  WovenProduct(int id, String name, String description, String image, int price,
      List<String> options, int stock)
      : super(id, name, 'Woven', description, image, price, options, stock);
  @override
  String get originStory => 'Celebrating local weaving and craftsmanship.';
}
class DecorProduct extends LocalProduct {
  DecorProduct(int id, String name, String description, String image, int price,
      List<String> options, int stock)
      : super(id, name, 'Decor', description, image, price, options, stock);
  @override
  String get originStory => 'An artistic piece celebrating Filipino homes.';
}

class CartLine {
  final LocalProduct product;
  final String option;
  int quantity;
  CartLine(this.product, this.option, this.quantity);
  int get total => quantity * product.price;
}
class SintaOrder {
  final int number;
  final List<CartLine> lines;
  final int total;
  final String customer;
  final String address;
  String status = 'Placed';
  int rating = 0;
  String review = '';
  SintaOrder(this.number, this.lines, this.total, this.customer, this.address);
}
class Customer {
  String name;
  String email;
  String password;
  String phone = '';
  String address = '';
  Customer(this.name, this.email, this.password);
}

// OOP pillar 4: ENCAPSULATION. Items are private; use public methods to edit.
class ShoppingCart {
  final List<CartLine> _lines = [];
  List<CartLine> get lines => List.from(_lines);
  int get total {
    int sum = 0;
    for (CartLine line in _lines) { sum += line.total; }
    return sum;
  }
  int get count {
    int sum = 0;
    for (CartLine line in _lines) { sum += line.quantity; }
    return sum;
  }
  int quantityOf(LocalProduct product) {
    int sum = 0;
    for (CartLine line in _lines) {
      if (line.product.id == product.id) sum += line.quantity;
    }
    return sum;
  }
  String? add(LocalProduct product, String option, int quantity) {
    if (quantity < 1) return 'Quantity must be at least 1.';
    if (quantityOf(product) + quantity > product.stock) {
      return 'Only ${product.stock} available for ${product.name}.';
    }
    for (CartLine line in _lines) {
      if (line.product.id == product.id && line.option == option) {
        line.quantity += quantity;
        return null;
      }
    }
    _lines.add(CartLine(product, option, quantity));
    return null;
  }
  bool increase(CartLine line) {
    if (quantityOf(line.product) >= line.product.stock) return false;
    line.quantity++;
    return true;
  }
  void decrease(CartLine line) { if (line.quantity > 1) line.quantity--; }
  void remove(CartLine line) { _lines.remove(line); }
  void clear() { _lines.clear(); }
}

class SintaApp extends StatelessWidget {
  const SintaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sinta',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: maroon),
        appBarTheme: const AppBarTheme(backgroundColor: cream, foregroundColor: dark),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const SintaHome(),
    );
  }
}

class SintaHome extends StatefulWidget {
  const SintaHome({super.key});
  @override
  State<SintaHome> createState() => _SintaHomeState();
}

class _SintaHomeState extends State<SintaHome> {
  // Only variables, lists, classes, and setState(). No database or plugins.
  final List<LocalProduct> products = [
    Souvenir(1, 'Jeepney Folding Fan', 'Decorated folding fan inspired by Philippine jeepneys.',
      'https://papemelroti.com/cdn/shop/files/7501-2JeepneyBlack.jpg?v=1712885101', 359,
      ['Black', 'Natural'], 12),
    Souvenir(2, 'Jeepney Keychain', 'Jeepney-themed souvenir for bags and keys.',
      'https://rootscollective.ph/cdn/shop/files/8_314f95d4-b549-4273-ae8c-7bb23a77ec44.png?v=1694758476', 249,
      ['Classic', 'Colorful'], 30),
    Souvenir(3, 'Wooden Sungka Set', 'Traditional Filipino board game with shells.',
      'assets/images/sungka.png', 680, ['Classic', 'Carved'], 9),
    Souvenir(4, 'Traditional Trumpo', 'Painted wooden spinning top with rope.',
      'assets/images/trumpo.png', 190, ['Red', 'Natural'], 17),
    DecorProduct(5, 'Jeepney Wall Art', 'Framed jeepney art for the home.',
      'https://papemelroti.com/cdn/shop/files/778-9R_Jeepney_Pag-Ibig_e86361df-7ffc-4d51-a4c2-b60bdbcac396.jpg?v=1683617179', 998,
      ['Small', 'Large'], 6),
    Souvenir(6, 'Colorful Wooden Yo-yo', 'Hand-painted wooden yo-yo.',
      'assets/images/yo_yo.png', 220, ['Multi-color', 'Red & green'], 14),
    DecorProduct(7, 'Capiz Star Parol', 'Traditional Filipino star lantern inspired by capiz craftsmanship.',
      'https://commons.wikimedia.org/wiki/Special:FilePath/Simple_capiz_parol.jpg', 540, ['Red & gold', 'White & gold'], 10),
    WovenProduct(8, 'Abaca Market Tote', 'Woven market tote inspired by Filipino craftsmanship.',
      'assets/images/abaca_tote.png', 699, ['Natural', 'Brown', 'Olive'], 8),
    WovenProduct(9, 'Sepak Takraw Ball', 'Handwoven sports ball used in traditional games.',
      'assets/images/takraw.png', 320, ['Natural', 'Yellow'], 11),
    Souvenir(10, 'Classic Wooden Yo-yo', 'Polished wooden yo-yo with string.',
      'assets/images/wooden_yoyo.png', 170, ['Wood brown', 'Dark brown'], 20),
  ];
  final ShoppingCart cart = ShoppingCart();
  final List<SintaOrder> orders = [];
  final List<Customer> customers = [Customer('Sinta Customer', 'customer@sinta.com', 'Sinta123')];
  Customer? signedIn;

  // Screens: 0 splash, 1 account, 2 main tabs, 3 details,
  // 4 checkout, 5 order details, 6 contact. No Navigator needed.
  int screen = 0;
  int tab = 0;
  bool registering = false;
  bool hidePassword = true;
  String authError = '';
  String search = '';
  String category = 'All';
  LocalProduct? chosenProduct;
  String chosenOption = '';
  int chosenQuantity = 1;
  SintaOrder? chosenOrder;
  ShoppingCart? checkoutCart;
  bool directBuy = false;
  String payment = 'Cash on Delivery';
  int selectedStars = 5;
  final GlobalKey<FormState> authForm = GlobalKey<FormState>();
  final GlobalKey<FormState> checkoutForm = GlobalKey<FormState>();
  final GlobalKey<FormState> contactForm = GlobalKey<FormState>();
  String authName = '';
  String authEmail = '';
  String authPassword = '';
  String authConfirmation = '';
  String checkoutName = '';
  String checkoutPhone = '';
  String checkoutEmail = '';
  String checkoutAddress = '';
  String reviewText = '';
  String contactMessage = '';
  final List<String> contactMessages = [];

  void notice(String text) {
    showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Sinta'), content: Text(text), actions: [
        ElevatedButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('OK')),
      ],
    ));
  }
  String? emailError(String? raw) {
    String value = (raw ?? '').trim();
    if (value.isEmpty || !value.contains('@') || !value.contains('.') || value.contains(' ')) {
      return 'Enter a valid email address.';
    }
    return null;
  }
  String? passwordError(String? value) {
    if ((value ?? '').length < 6) return 'Password needs at least 6 characters.';
    return null;
  }
  void submitAuth() {
    if (!(authForm.currentState?.validate() ?? false)) return;
    authForm.currentState!.save();
    if (registering) {
      if (authPassword != authConfirmation) {
        setState(() => authError = 'Passwords do not match.');
        return;
      }
      for (Customer c in customers) {
        if (c.email.toLowerCase() == authEmail.toLowerCase()) {
          setState(() => authError = 'Email already registered.');
          return;
        }
      }
      Customer c = Customer(authName.trim(), authEmail.trim().toLowerCase(), authPassword);
      setState(() { customers.add(c); signedIn = c; screen = 2; tab = 0; authError = ''; });
    } else {
      for (Customer c in customers) {
        if (c.email.toLowerCase() == authEmail.trim().toLowerCase() && c.password == authPassword) {
          setState(() { signedIn = c; screen = 2; tab = 0; authError = ''; });
          return;
        }
      }
      setState(() => authError = 'Incorrect email or password.');
    }
  }
  void openProduct(LocalProduct product) {
    setState(() {
      chosenProduct = product; chosenOption = product.options.first;
      chosenQuantity = 1; screen = 3;
    });
  }
  void startCheckout(ShoppingCart selected, bool buyNow) {
    if (selected.lines.isEmpty) { notice('Your cart is empty.'); return; }
    setState(() { checkoutCart = selected; directBuy = buyNow; screen = 4; });
  }
  void buyNow() {
    if (chosenProduct == null) return;
    ShoppingCart single = ShoppingCart();
    String? problem = single.add(chosenProduct!, chosenOption, chosenQuantity);
    if (problem != null) { notice(problem); return; }
    startCheckout(single, true);
  }
  Future<void> removeLine(CartLine line) async {
    bool? yes = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('Remove item?'),
      content: Text('Reducing ${line.product.name} to 0 will remove this product from your cart.'),
      actions: [
        ElevatedButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
      ],
    ));
    if (yes == true && mounted) setState(() => cart.remove(line));
  }
  String? phoneError(String? raw) {
    String v = (raw ?? '').trim().replaceAll(' ', '').replaceAll('-', '');
    if (v.length == 13 && v.startsWith('+63')) v = '0${v.substring(3)}';
    if (v.length != 11 || !v.startsWith('09')) return 'Use 09XXXXXXXXX or +639XXXXXXXXX.';
    for (int i = 0; i < v.length; i++) {
      if (!'0123456789'.contains(v[i])) return 'Numbers only, please.';
    }
    return null;
  }
  void placeOrder() {
    if (!(checkoutForm.currentState?.validate() ?? false)) return;
    checkoutForm.currentState!.save();
    ShoppingCart selected = checkoutCart!;
    for (CartLine line in selected.lines) {
      if (line.quantity > line.product.stock) {
        notice('Not enough stock for ${line.product.name}.'); return;
      }
    }
    try {
      signedIn!.name = checkoutName;
      signedIn!.phone = checkoutPhone;
      signedIn!.address = checkoutAddress;
      List<CartLine> orderLines = [];
      for (CartLine line in selected.lines) {
        orderLines.add(CartLine(line.product, line.option, line.quantity));
        line.product.stock -= line.quantity;
      }
      SintaOrder order = SintaOrder(1001 + orders.length, orderLines,
          selected.total + deliveryFee, checkoutName, checkoutAddress);
      setState(() {
        orders.insert(0, order);
        if (!directBuy) cart.clear();
        chosenOrder = order;
        screen = 5;
        tab = 3;
      });
      notice('Order placed! Thank you for supporting local products.');
    } catch (error) {
      notice('Something went wrong. Please try again.');
    }
  }
  void buyAgain(SintaOrder order) {
    String? problem;
    setState(() {
      for (CartLine line in order.lines) {
        String? result = cart.add(line.product, line.option, line.quantity);
        if (result != null) problem = result;
      }
      screen = 2; tab = 2;
    });
    notice(problem ?? 'Available items added to your cart.');
  }

  Widget titleText(String value, {double size = 25}) => Text(value,
    style: TextStyle(fontFamily: 'serif', fontSize: size, color: brown,
      fontWeight: FontWeight.bold));
  Widget gap(double amount) => SizedBox(height: amount);
  Widget picture(LocalProduct product, {double height = 145}) {
    Widget placeholder = Container(color: beige,
      child: const Center(child: Icon(Icons.image_outlined, size: 42, color: maroon)));
    if (product.image.startsWith('assets/')) {
      return Image.asset(product.image, width: double.infinity, height: height,
        fit: BoxFit.contain, errorBuilder: (context, error, stack) => placeholder);
    }
    return Image.network(product.image, width: double.infinity, height: height,
      fit: BoxFit.contain, errorBuilder: (context, error, stack) => placeholder);
  }
  Widget action(String label, VoidCallback? onTap) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: maroon, foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14)), child: Text(label)));

  Widget sectionHeading(String title, String caption) => Row(children: [
    Expanded(child: titleText(title, size: 23)),
    Text(caption, style: const TextStyle(fontSize: 11, color: maroon)),
  ]);

  Widget categoryButtons() => Row(children: [
    for (String group in ['All', 'Souvenirs', 'Woven', 'Decor'])
      Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
        child: SizedBox(height: 37, child: ElevatedButton(
          onPressed: () => setState(() { category = group; tab = 1; }),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            backgroundColor: category == group ? maroon : Colors.white,
            foregroundColor: category == group ? Colors.white : brown,
            elevation: category == group ? 1 : 0),
          child: Text(group, style: const TextStyle(fontSize: 10)),
        )))),
  ]);

  Widget productCard(LocalProduct product) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFFFFDF9),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFEEDFCC)),
      boxShadow: const [BoxShadow(color: Color(0x1C543126), blurRadius: 8,
        offset: Offset(0, 3))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 116,
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(color: Color(0xFFF9F0E5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
        child: picture(product, height: 106)),
      Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(9, 7, 9, 7),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          Text(peso(product.price), style: const TextStyle(
            fontSize: 15, color: maroon, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(product.stock == 0 ? 'Out of stock' : '${product.stock} left in stock',
            style: TextStyle(fontSize: 10,
              color: product.stock == 0 ? maroon : brown)),
          const SizedBox(height: 6),
          SizedBox(height: 29, width: double.infinity,
            child: ElevatedButton(onPressed: () => openProduct(product),
              style: ElevatedButton.styleFrom(backgroundColor: beige,
                foregroundColor: maroon, padding: EdgeInsets.zero, elevation: 0),
              child: const Text('View Details', style: TextStyle(fontSize: 11)))),
        ]))),
    ]));

    Widget splash() => Center(child: Padding(padding: const EdgeInsets.all(26),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset('assets/images/sinta_logo.png', width: 180, height: 180),
      gap(20), titleText('Sinta', size: 64),
      const Text('FILIPINO HANDICRAFTS & SOUVENIRS', textAlign: TextAlign.center,
        style: TextStyle(letterSpacing: 2, fontSize: 11, color: maroon)),
      gap(25), titleText('Gawang Lokal, Gawang May Puso', size: 25),
      gap(24), action('Get Started', () => setState(() => screen = 1)),
    ])));

  Widget login() => ListView(padding: const EdgeInsets.all(24), children: [
    gap(18), Center(child: Image.asset('assets/images/sinta_logo.png', width: 100, height: 100)),
    gap(10), Center(child: titleText(registering ? 'Create an Account' : 'Welcome Back!', size: 30)),
    gap(12), const Center(child: Text('Thank you for supporting local products.')),
    gap(20), Form(key: authForm, child: Column(children: [
      if (registering) TextFormField(
        decoration: const InputDecoration(labelText: 'Full Name'),
        validator: (v) => (v ?? '').trim().length < 3 ? 'Enter your full name.' : null,
        onSaved: (v) => authName = (v ?? '').trim()),
      if (registering) gap(12),
      TextFormField(keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(labelText: 'Email'),
        validator: emailError, onSaved: (v) => authEmail = (v ?? '').trim()),
      gap(12), TextFormField(obscureText: hidePassword,
        decoration: const InputDecoration(labelText: 'Password'),
        validator: passwordError, onSaved: (v) => authPassword = v ?? ''),
      if (registering) gap(12),
      if (registering) TextFormField(obscureText: hidePassword,
        decoration: const InputDecoration(labelText: 'Confirm Password'),
        validator: passwordError, onSaved: (v) => authConfirmation = v ?? ''),
    ])),
    if (authError.isNotEmpty) Padding(padding: const EdgeInsets.all(10),
      child: Text(authError, style: const TextStyle(color: maroon))),
    gap(16), action(registering ? 'Sign Up' : 'Log In', submitAuth),
    ElevatedButton(onPressed: () => setState(() {
      registering = !registering; authError = '';
    }), child: Text(registering ? 'Have an account? Log In' : 'New here? Sign Up')),
    const Text('Classroom account: customer@sinta.com / Sinta123\n'
      'Accounts are for this app session only. Do not use a real password.',
      textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: brown)),
  ]);

  Widget homeTab() => ListView(padding: const EdgeInsets.fromLTRB(16, 10, 16, 22), children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(color: brown, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('G A W A N G   P I N O Y', style: TextStyle(
          fontSize: 10, letterSpacing: 1.5, color: Color(0xFFF4DDBD))),
        gap(8), const Text('Gawang Lokal,\nGawang May Puso.',
          style: TextStyle(fontFamily: 'serif', color: Colors.white,
          fontWeight: FontWeight.bold, fontSize: 28, height: 1.12)),
        gap(9), const Text('Handpicked Filipino treasures for every occasion.',
          style: TextStyle(color: Color(0xFFF9E9D4), fontSize: 12)),
        gap(13), ElevatedButton(
          onPressed: () => setState(() { category = 'All'; tab = 1; }),
          style: ElevatedButton.styleFrom(backgroundColor: cream, foregroundColor: maroon),
          child: const Text('Explore Collection  →')),
      ])),
    gap(20), sectionHeading('Shop by Category', 'Made with care'), gap(10),
    categoryButtons(), gap(20),
    sectionHeading('Featured Finds', '10 local products'), gap(10),
    GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2, childAspectRatio: 0.76, crossAxisSpacing: 11,
      mainAxisSpacing: 11,
      children: [for (int i = 0; i < 4; i++) productCard(products[i])]),
    gap(15), Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: beige, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        titleText('Salamat sa pagtangkilik!', size: 19), gap(5),
        const Text('Thank you for supporting local products.',
          style: TextStyle(fontSize: 12, color: brown)),
        gap(7), ElevatedButton(onPressed: () => setState(() { category = 'All'; tab = 1; }),
          child: const Text('See All Products')),
      ])),
  ]);

  Widget shopTab() {
    List<LocalProduct> results = [];
    for (LocalProduct item in products) {
      if (item.name.toLowerCase().contains(search.toLowerCase()) &&
          (category == 'All' || category == item.category)) results.add(item);
    }
    return ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 22), children: [
      titleText('Shop Local Treasures', size: 27), gap(12),
      TextFormField(initialValue: search,
        decoration: const InputDecoration(prefixIcon: Icon(Icons.search),
          hintText: 'Search local products', isDense: true),
        onChanged: (value) => setState(() => search = value)),
      gap(12), categoryButtons(), gap(12),
      Row(children: [
        Text('${results.length} products', style: const TextStyle(color: brown, fontSize: 12)),
        const Expanded(child: SizedBox()),
        const Text('Filipino crafts & gifts', style: TextStyle(color: brown, fontSize: 11)),
      ]), gap(12),
      if (results.isEmpty) Padding(padding: const EdgeInsets.all(24),
        child: Column(children: [
          const Icon(Icons.search_off_outlined, size: 38, color: maroon), gap(9),
          const Text('No products found. Try another search.'),
        ])),
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2, childAspectRatio: 0.76, crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        children: [for (LocalProduct item in results) productCard(item)]),
    ]);
  }

  Widget detailsPage() {
    LocalProduct p = chosenProduct!;
    return ListView(padding: const EdgeInsets.fromLTRB(18, 10, 18, 22), children: [
      Container(
        height: 210,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: beige)),
        child: picture(p, height: 185)),
      gap(14),
      titleText(p.name, size: 27),
      gap(5),
      Row(children: [
        Text(peso(p.price), style: const TextStyle(
          fontSize: 23, fontWeight: FontWeight.bold, color: maroon)),
        const Expanded(child: SizedBox()),
        Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(color: beige, borderRadius: BorderRadius.circular(15)),
          child: Text(p.stock == 0 ? 'Out of stock' : '${p.stock} in stock',
            style: const TextStyle(fontSize: 12, color: maroon))),
      ]),
      gap(12),
      Text(p.description, style: const TextStyle(fontSize: 13, height: 1.4)),
      gap(20),
      const Text('Choose option', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      gap(9),
      Row(children: [
        for (String option in p.options)
          Expanded(child: Padding(padding: const EdgeInsets.only(right: 5),
            child: SizedBox(height: 40, child: ElevatedButton(
              onPressed: () => setState(() => chosenOption = option),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                backgroundColor: chosenOption == option ? maroon : Colors.white,
                foregroundColor: chosenOption == option ? Colors.white : brown,
                elevation: 0),
              child: Text(option, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11)))))),
      ]),
      gap(20),
      Row(children: [
        const Text('Quantity', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const Expanded(child: SizedBox()),
        SizedBox(width: 44, height: 38, child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: chosenQuantity > 1 ? () => setState(() => chosenQuantity--) : null,
          child: const Text('−', style: TextStyle(fontSize: 20)))),
        SizedBox(width: 44, child: Center(child: Text('$chosenQuantity',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
        SizedBox(width: 44, height: 38, child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: chosenQuantity < p.stock ? () => setState(() => chosenQuantity++) : null,
          child: const Text('+', style: TextStyle(fontSize: 20)))),
      ]),
      gap(21),
      Row(children: [
        Expanded(child: SizedBox(height: 48, child: ElevatedButton(
          onPressed: p.stock == 0 ? null : () {
            String? error = cart.add(p, chosenOption, chosenQuantity);
            if (error != null) { notice(error); return; }
            setState(() { screen = 2; tab = 2; });
            notice('Added to your cart.');
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
            foregroundColor: maroon, elevation: 0, side: const BorderSide(color: maroon)),
          child: const Text('Add to Cart', style: TextStyle(fontSize: 12))))),
        const SizedBox(width: 10),
        Expanded(child: SizedBox(height: 48, child: ElevatedButton(
          onPressed: p.stock == 0 ? null : buyNow,
          style: ElevatedButton.styleFrom(backgroundColor: maroon,
            foregroundColor: Colors.white, elevation: 0),
          child: const Text('Buy Now', style: TextStyle(fontSize: 13))))),
      ]),
    ]);
  }

  Widget cartTab() => ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 22), children: [
    sectionHeading('My Cart', '${cart.count} items'), gap(13),
    if (cart.lines.isEmpty) Container(
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        const Icon(Icons.shopping_bag_outlined, size: 42, color: maroon), gap(10),
        titleText('Your cart is empty', size: 21), gap(5),
        const Text('Discover something made with Filipino heart.',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        gap(14), action('Browse Products', () => setState(() => tab = 1)),
      ])),
    for (CartLine line in cart.lines) Padding(padding: const EdgeInsets.only(bottom: 11),
      child: Container(padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: beige)),
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(color: cream, width: 80, height: 80,
              child: picture(line.product, height: 80)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(line.product.name, maxLines: 2,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              gap(4), Text('Option: ${line.option}',
                style: const TextStyle(color: brown, fontSize: 11)),
              gap(4), Text(peso(line.total), style: const TextStyle(
                color: maroon, fontWeight: FontWeight.bold, fontSize: 16)),
            ])),
          ]), gap(10),
          Row(children: [
            const Text('Quantity', style: TextStyle(fontSize: 12, color: brown)),
            const Expanded(child: SizedBox()),
            SizedBox(width: 43, height: 34, child: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () {
                if (line.quantity == 1) { removeLine(line); }
                else { setState(() => cart.decrease(line)); }
              }, child: const Text('−'))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 11),
              child: Text('${line.quantity}')),
            SizedBox(width: 43, height: 34, child: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () {
                if (!cart.increase(line)) notice('Stock limit reached.');
                setState(() {});
              }, child: const Text('+'))),
            const SizedBox(width: 5),
            SizedBox(height: 34, child: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 9)),
              onPressed: () => removeLine(line), child: const Text('Remove',
                style: TextStyle(fontSize: 10)))),
          ]),
        ]))),
    if (cart.lines.isNotEmpty) ...[
      gap(7), Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(children: [
          Row(children: [const Text('Subtotal'), const Expanded(child: SizedBox()),
            Text(peso(cart.total))]), gap(9),
          Row(children: [const Text('Delivery'), const Expanded(child: SizedBox()),
            Text(peso(deliveryFee))]), gap(10),
          Container(height: 1, color: beige), gap(10),
          Row(children: [titleText('Total', size: 22), const Expanded(child: SizedBox()),
            titleText(peso(cart.total + deliveryFee), size: 22)]),
        ])), gap(14),
      action('Proceed to Checkout  →', () => startCheckout(cart, false)),
    ],
  ]);

    Widget checkoutPage() {
    ShoppingCart currentCart = checkoutCart!;
    return ListView(padding: const EdgeInsets.all(18), children: [
      titleText('Shipping Information'), gap(12),
      const Text('Details are remembered during this app session.'), gap(16),
      Form(key: checkoutForm, child: Column(children: [
        TextFormField(initialValue: signedIn!.name,
          decoration: const InputDecoration(labelText: 'Full Name'),
          validator: (v) => (v ?? '').trim().length < 3 ? 'Enter your full name.' : null,
          onSaved: (v) => checkoutName = (v ?? '').trim()), gap(12),
        TextFormField(initialValue: signedIn!.phone,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: 'Philippine Mobile Number'),
          validator: phoneError,
          onSaved: (v) => checkoutPhone = (v ?? '').trim()), gap(12),
        TextFormField(initialValue: signedIn!.email,
          decoration: const InputDecoration(labelText: 'Email'),
          validator: emailError,
          onSaved: (v) => checkoutEmail = (v ?? '').trim()), gap(12),
        TextFormField(initialValue: signedIn!.address, maxLines: 2,
          decoration: const InputDecoration(labelText: 'Street, Barangay, City, Province'),
          validator: (v) => (v ?? '').trim().length < 12 ? 'Enter your full delivery address.' : null,
          onSaved: (v) => checkoutAddress = (v ?? '').trim()),
      ])),
      gap(20), titleText('Payment'), gap(5),
      const Text('Cash on Delivery (COD)'),
      gap(20), titleText('Order Summary'),
      for (CartLine line in currentCart.lines) Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [Expanded(child: Text('${line.product.name} (${line.option}) × ${line.quantity}')),
          Text(peso(line.total))])),
      Container(height: 1, color: beige), Text('Delivery: ${peso(deliveryFee)}'),
      titleText('Total: ${peso(currentCart.total + deliveryFee)}', size: 26),
      gap(17), action('Place Order', placeOrder),
      gap(8), const Text('Classroom project: orders are recorded within the app only. '
        'No real payments or deliveries are arranged.', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: brown)),
    ]);
  }

  Widget ordersTab() => ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 22), children: [
    sectionHeading('My Orders', '${orders.length} orders'), gap(13),
    if (orders.isEmpty) Container(padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        const Icon(Icons.receipt_long_outlined, size: 40, color: maroon), gap(10),
        titleText('No orders yet', size: 22), gap(4),
        const Text('Your local finds will appear here after checkout.',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        gap(14), action('Start Shopping', () => setState(() => tab = 1)),
      ])),
    for (SintaOrder order in orders) Padding(padding: const EdgeInsets.only(bottom: 12),
      child: Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(14), border: Border.all(color: beige)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text('Order #SNT-${order.number}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: beige,
                borderRadius: BorderRadius.circular(16)),
              child: Text(order.status, style: const TextStyle(
                color: maroon, fontSize: 11, fontWeight: FontWeight.bold))),
          ]), gap(10),
          Text('${order.lines.length} product types  •  Cash on Delivery',
            style: const TextStyle(fontSize: 11, color: brown)), gap(5),
          for (CartLine line in order.lines)
            Text('${line.quantity} × ${line.product.name} (${line.option})',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11)),
          gap(10), Container(height: 1, color: beige), gap(10),
          Row(children: [
            titleText(peso(order.total), size: 20), const Expanded(child: SizedBox()),
            ElevatedButton(onPressed: () => setState(() { chosenOrder = order; screen = 5; }),
              child: const Text('View Order  →')),
          ]),
        ]))),
  ]);

    Widget orderPage() {
    SintaOrder order = chosenOrder!;
    List<String> statuses = ['Placed', 'Preparing', 'Shipped', 'Delivered', 'Completed'];
    int index = statuses.indexOf(order.status);
    return ListView(padding: const EdgeInsets.all(18), children: [
      const Icon(Icons.check_circle_outline, color: maroon, size: 60),
      gap(10), Center(child: titleText('Order #SNT-${order.number}')),
      gap(6), const Center(child: Text('Thank you for supporting local products.')),
      gap(18), titleText('Order Progress'),
      for (int i = 0; i < statuses.length; i++)
        Padding(padding: const EdgeInsets.all(7), child: Row(children: [
          Icon(i <= index ? Icons.check_circle : Icons.radio_button_unchecked,
            color: i <= index ? maroon : Colors.grey),
          const SizedBox(width: 10), Text(statuses[i]),
        ])),
      const Text('Order tracking is manually updated for classroom testing.',
        style: TextStyle(fontSize: 11, color: brown)),
      if (index < statuses.length - 1) ElevatedButton(
        onPressed: () => setState(() => order.status = statuses[index + 1]),
        child: const Text('Advance Status (Project Testing)')),
      gap(15), titleText('Items'),
      for (CartLine line in order.lines) Padding(
        padding: const EdgeInsets.all(8), child: Column(children: [
          Text('${line.product.name} × ${line.quantity} — ${peso(line.total)}'),
          Text('Option: ${line.option}'),
        ])),
      Container(height: 1, color: beige),
      titleText('Cash on Delivery: ${peso(order.total)}', size: 22),
      Text('Recipient: ${order.customer}'), Text('Address: ${order.address}'),
      gap(15), action('Buy Again', () => buyAgain(order)),
      if (order.status == 'Completed') ...[
        gap(20), titleText('Leave Feedback'),
        Row(children: [for (int n = 1; n <= 5; n++) Expanded(child: ElevatedButton(
          onPressed: () => setState(() => selectedStars = n),
          child: Text(n <= selectedStars ? '★' : '☆')))]),
        TextFormField(initialValue: order.review,
          decoration: const InputDecoration(labelText: 'Your review'),
          maxLines: 3, onChanged: (v) => reviewText = v),
        gap(10), action('Save Review', () {
          if (reviewText.trim().length < 5) { notice('Write at least 5 characters.'); return; }
          setState(() { order.rating = selectedStars; order.review = reviewText.trim(); });
          notice('Thank you for your feedback!');
        }),
      ],
    ]);
  }

  Widget profileTab() => ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 22), children: [
    titleText('My Profile', size: 27), gap(13),
    Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15),
        border: Border.all(color: beige)),
      child: Row(children: [
        Image.asset('assets/images/sinta_logo.png', width: 64, height: 64),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          titleText(signedIn!.name, size: 22), gap(4),
          Text(signedIn!.email, style: const TextStyle(fontSize: 12, color: brown)),
          gap(4), const Text('Sinta member  •  Thank you for supporting local!',
            style: TextStyle(fontSize: 10, color: maroon)),
        ])),
      ])), gap(17),
    titleText('Delivery Information', size: 22), gap(9),
    Container(padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Saved contact number', style: TextStyle(fontSize: 11, color: brown)),
        Text(signedIn!.phone.isEmpty ? 'Add at checkout' : signedIn!.phone), gap(10),
        const Text('Saved address', style: TextStyle(fontSize: 11, color: brown)),
        Text(signedIn!.address.isEmpty ? 'Add at checkout' : signedIn!.address),
      ])), gap(19),
    titleText('Account & Support', size: 22), gap(10),
    Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        action('My Order History  →', () => setState(() => tab = 3)), gap(8),
        action('Contact & Feedback  →', () => setState(() => screen = 6)), gap(8),
        ElevatedButton(onPressed: () => setState(() {
          signedIn = null; screen = 1; tab = 0; cart.clear();
        }), child: const Text('Log Out')),
      ])),
    gap(15), const Center(child: Text('Sinta • Gawang Lokal, Gawang May Puso.',
      style: TextStyle(fontSize: 11, color: brown))),
  ]);

    Widget contactPage() => ListView(padding: const EdgeInsets.all(20), children: [
    Center(child: titleText('Contact & Feedback')),
    gap(8), const Text('We appreciate your comments and suggestions.', textAlign: TextAlign.center),
    gap(25), Form(key: contactForm, child: TextFormField(
      decoration: const InputDecoration(labelText: 'Your message'), maxLines: 5,
      validator: (v) => (v ?? '').trim().length < 10 ? 'Enter at least 10 characters.' : null,
      onSaved: (v) => contactMessage = (v ?? '').trim())),
    gap(15), action('Save Feedback', () {
      if (!(contactForm.currentState?.validate() ?? false)) return;
      contactForm.currentState!.save();
      setState(() { contactMessages.add(contactMessage); screen = 2; tab = 4; });
      notice('Feedback recorded in this app session. Thank you!');
    }),
    gap(12), const Text('Feedback is stored only while this app is running. '
      'No messages are sent to a real business.',
      style: TextStyle(fontSize: 11, color: brown)),
  ]);

  Widget mainTab() {
    if (tab == 0) return homeTab();
    if (tab == 1) return shopTab();
    if (tab == 2) return cartTab();
    if (tab == 3) return ordersTab();
    return profileTab();
  }
  @override
  Widget build(BuildContext context) {
    String header = 'Sinta';
    if (screen == 3) header = 'Product Details';
    if (screen == 4) header = 'Checkout';
    if (screen == 5) header = 'My Order';
    if (screen == 6) header = 'Contact Us';
    return Scaffold(
      appBar: screen == 0 ? null : AppBar(
        leading: screen >= 3 ? ElevatedButton(
          onPressed: () => setState(() { screen = 2; }),
          child: const Icon(Icons.arrow_back)) : null,
        title: Text(header, style: const TextStyle(fontFamily: 'serif',
          fontWeight: FontWeight.bold, color: maroon, fontSize: 26)),
        centerTitle: true,
        actions: screen == 2 ? [ElevatedButton(
          onPressed: () => setState(() => tab = 2),
          child: const Icon(Icons.shopping_cart_outlined))] : null,
      ),
      body:
        screen == 0 ? splash() :
        screen == 1 ? login() :
        screen == 2 ? mainTab() :
        screen == 3 ? detailsPage() :
        screen == 4 ? checkoutPage() :
        screen == 5 ? orderPage() : contactPage(),
      bottomNavigationBar: screen == 2 ? BottomNavigationBar(
        currentIndex: tab, type: BottomNavigationBarType.fixed,
        selectedItemColor: maroon, unselectedItemColor: brown,
        onTap: (n) => setState(() => tab = n),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ) : null,
    );
  }
}
