<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us</title>
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
</head>
<body>
    <header>
        <h1>About Us</h1>
    </header>
    <main>
        <section>
            <h2>Our Mission</h2>
            <p>Our mission is to provide the best services to our customers and ensure their satisfaction.</p>
        </section>
        <section>
            <h2>Our Team</h2>
            <p>We have a dedicated team of professionals who are experts in their respective fields.</p>
        </section>
        <section>
            <h2>Contact Us</h2>
            <p>If you have any questions, feel free to <a href="{{ url('/contact') }}">contact us</a>.</p>
        </section>
    </main>
    <footer>
        <p>&copy; 2023 Your Company. All rights reserved.</p>
    </footer>
</body>
</html>