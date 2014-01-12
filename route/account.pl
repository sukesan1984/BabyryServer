+{
    '/register' => +{
        controller => 'Register', action => 'index',
    },
    '/register/execute' => +{
        controller => 'Register', action => 'execute',
        filter => [qw/validate_password/],
    },
    '/register/verify' => +{
        controller => 'Register', action => 'verify',
    },
}

