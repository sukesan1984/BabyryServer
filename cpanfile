requires 'Amon2', '6.00';
requires 'DBD::SQLite', '1.33';
requires 'HTML::FillInForm::Lite', '1.11';
requires 'HTTP::Session2', '0.04';
requires 'JSON', '2.50';
requires 'Module::Functions', '2';
requires 'Plack::Middleware::ReverseProxy', '0.09';
requires 'Router::Boom', '0.06';
requires 'Starlet', '0.20';
requires 'Teng', '0.18';
requires 'Test::WWW::Mechanize::PSGI';
requires 'Text::Xslate', '2.0009';
requires 'Time::Piece', '1.20';
requires 'perl', '5.010_001';
requires 'Log::Minimal', '0.17';
requires 'DBIx::DBHResolver', '0.17';
requires 'DBIx::Simple', '1.35';
requires 'DateTime', '1.06';
requires 'DBD::mysql', '4.025';

on configure => sub {
    requires 'Module::Build', '0.38';
    requires 'Module::CPANfile', '0.9010';
};

on test => sub {
    requires 'Test::More', '0.98';
};
