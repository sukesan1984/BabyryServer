+{
    '/register' => +{
        controller => 'Register', action => 'index',
    },
    '/register/execute' => +{
        controller => 'Register', action => 'execute',
        filter => [qw/validate_password/],
    },
    '/login' => +{
        controller => 'Login', action => 'index',
    },
    '/login/execute' => +{
        controller => 'Login', action => 'execute',
    },
}

