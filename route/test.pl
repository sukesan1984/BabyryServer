+{
    '/' => +{
        controller => 'Test', action => 'index',
    },
    '/reset_counter' => +{
        controller => 'Test', action => 'reset_counter',
    },
    '/account/logout' => +{
        controller => 'Test', action => 'account_logout',
    },
    '/message/add' => +{
        controller => 'Test', action => 'message_add',
    },
    '/json_validate_sample' => +{
        controller => 'Test', action => 'json_validate_sample',
        filters => [qw/validator/]
    }
}

