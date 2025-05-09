<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class VerifiedSeller
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */

public function handle($request, Closure $next)
{
    if (!auth()->check() || !auth()->user()->isVerifiedSeller()) {
        return redirect()->route('home')->with('error', 'You need to be a verified seller to access this page.');
    }
    
    return $next($request);
}
}
