<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\testModel;

class testController extends Controller
{
    //
    
    function index(){
        $test = testModel::all();
        return view('test',  compact('test'));
    }
}
