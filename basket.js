document.addEventListener('DOMContentLoaded', () => {
    const cartItemsContainer = document.getElementById('cart-items');
    const checkoutButton = document.getElementById('checkout-button');
    const emptyCartMessage = document.getElementById('empty-cart-message');

    let cart = JSON.parse(localStorage.getItem('cart')) || [];

    function updateCart() {
        cartItemsContainer.innerHTML = '';
        if (cart.length === 0) {
            emptyCartMessage.style.display = 'block';
            checkoutButton.style.display = 'none';
        } else {
            emptyCartMessage.style.display = 'none';
            checkoutButton.style.display = 'block';
            cart.forEach((item, index) => {
                const itemElement = document.createElement('div');
                itemElement.classList.add('col-12', 'col-md-6', 'col-lg-4', 'mb-4');
                itemElement.innerHTML = `
                    <div class="card h-100">
                        <img src="${item.image}" class="card-img-top" alt="${item.name}">
                        <div class="card-body">
                            <h5 class="card-title">${item.name}</h5>
                            <p class="card-text">${item.price}</p>
                            <button class="btn btn-danger remove-from-cart" data-index="${index}">Видалити</button>
                        </div>
                    </div>
                `;
                cartItemsContainer.appendChild(itemElement);
            });

            document.querySelectorAll('.remove-from-cart').forEach(button => {
                button.addEventListener('click', (event) => {
                    const index = event.target.dataset.index;
                    cart.splice(index, 1);
                    localStorage.setItem('cart', JSON.stringify(cart));
                    updateCart();
                });
            });
        }
    }

    checkoutButton.addEventListener('click', () => {
        window.location.href = 'acount.html';
    });

    updateCart();
});
