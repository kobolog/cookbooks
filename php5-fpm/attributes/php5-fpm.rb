default[:fpm][:config] = "/etc/php5/fpm"

default[:fpm][:log] = {
  :path => '/var/log/php5-fpm.log',
  :level => 'notice',
  :rotate => 'daily',
  :keep => 30
}

default[:fpm][:user] = 'www-data'

default[:fpm][:modules] = [
  'mysql',
  'gd'
]

default[:fpm][:pools] = {
  :pool_0 => {
    :address => '127.0.0.1:9000',
    :allow => '127.0.0.1',
    :backlog => -1,
    :limits => {
      :core => 0,
      :files => 1024,
      :requests => 500,
      :children => 50,
      :spare_children => {
        :min => 5,
        :max => 35
      }
    },
    :php => {
      'register_globals' => true,
      'short_open_tag' => true,
      'display_errors' => false,
      'error_reporting' => 'E_ALL &amp; ~E_DEPRECATED',
      'max_execution_time' => '60',
      'date.timezone' => 'Europe/Moscow'
    }
  }
}
