<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us</title>
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
</head>
<body>
    <main>
       <h1>test page</h1>
       <p>name</p>
       
        @foreach($test as $item)
            <p>{{ $item->test_Name }}</p>
        @endforeach

       
    </main>
</body>
</html>