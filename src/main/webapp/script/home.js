let cart = [];
let cartCount = 0;

function addToCart(name, price) {
    cart.push({ name, price });
    cartCount++;
    document.getElementById("cart-count").innerText = cartCount;
    alert(name + " added to cart!");
}

function viewCart() {
    if (cart.length === 0) {
        alert("Cart is empty!");
        return;
    }

    let message = "Your Cart:\n\n";
    let total = 0;

    cart.forEach(item => {
        message += item.name + " - $" + item.price + "\n";
        total += item.price;
    });

    message += "\nTotal: $" + total;

    alert(message);
}