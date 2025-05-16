<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Auth\Notifications\VerifyEmail;
use Illuminate\Support\Facades\URL;


class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot()
    {
        VerifyEmail::createUrlUsing(function ($notifiable) {
            $appUrl = config('app.frontend_url'); // Set this in .env
            $temporarySignedRoute = URL::temporarySignedRoute(
                'verification.verify',
                now()->addMinutes(60),
                ['id' => $notifiable->getKey(), 'hash' => sha1($notifiable->getEmailForVerification())]
            );

            // Replace backend URL with custom Flutter deep link
            return str_replace(config('app.url'), 'cipeats://email-verify', $temporarySignedRoute);
        });
    }
}
