# encoding: utf-8

maintainer          "Андрей Сибирёв"
maintainer_email    "me@kobology.ru"
license             "Apache 2.0"
description         "Устанавливает и настраивает PHP5-FPM"
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.textile'))
version             "0.1.0"

%w{ ubuntu debian }.each do |os|
    supports os
end

depends "nginx"

attribute "fpm/config",
  :display_name => "Директория с конфигурационными файлами",
  :default => "/etc/php5/fpm"

grouping "fpm/log",
    :title => "Настройки логирования"

attribute "fpm/log/path",
    :display_name => "Полный путь до лог-файла",
    :default => "/var/log"

attribute "fpm/log/level",
    :display_name => "Уровень логирования",
    :default => "notice",
    :choice => ["notice", "debug"]

attribute "fpm/log/rotate",
    :display_name => "Периодичность ротации логов",
    :default => "daily",
    :choice => ["daily", "weekly", "monthly"]

attribute "fpm/log/keep",
    :display_name => "Время хранения ротированных копий",
    :description => "Устанавливает количество циклов ротирования, после которого лог файл будет удалён",
    :default => "30"

attribute "fpm/user",
    :display_name => "Имя пользователя, под которым будет работать сервис",
    :default => "www-data"

grouping "fpm/pools",
    :title => "Пулы",
    :description => "Здесь настраиваются рабочие пулы"
