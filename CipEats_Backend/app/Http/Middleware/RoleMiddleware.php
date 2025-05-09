<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class RoleMiddleware
{
    public function handle(Request $request, Closure $next, $role)
    {
        $user = $request->user();

        if (!$user || !$user->roles->contains('name', $role)) {
            abort(403, 'Unauthorized action.');
        }

        return $next($request);
    }
}
