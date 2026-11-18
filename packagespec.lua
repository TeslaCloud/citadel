Package:describe(function(s)
  s.name        = 'Citadel'
  s.version     = '1.0.0'
  s.date        = '2026-11-17'
  s.summary     = 'The lobby of a Flux server network.'
  s.license     = 'MIT'

  s.depends('flux', '~> 0.9')

  -- Uncomment the dependency of the database driver the server uses, then run `fpkg install`.
  -- SQLite needs none. MySQL and MariaDB use mysqloo, which is not an fpkg package yet:
  -- copy its module to garrysmod/lua/bin by hand.
  -- s.depends 'gmsv_pg'
end)
