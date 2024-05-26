document.addEventListener('DOMContentLoaded', () => {
    const cartButtons = document.querySelectorAll('.add-to-cart');

    cartButtons.forEach(button => {
        button.addEventListener('click', (event) => {
            event.preventDefault();
            const card = button.closest('.card');
            const product = {
                image: card.querySelector('img').src,
                name: card.querySelectorAll('.card-text')[0].textContent,
                price: card.querySelectorAll('.card-text')[1].textContent
            };

            addToCart(product);
        });
    });

    function addToCart(product) {
        let cart = JSON.parse(localStorage.getItem('cart')) || [];
        cart.push(product);
        localStorage.setItem('cart', JSON.stringify(cart));
        alert('Товар додано до кошика!');
    }
});
