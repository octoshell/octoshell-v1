# Автоматизированные резервные копии для Octoshell

Для установки потребуется руби 2.0:

```bash
rbenv shell 2.0.0-p0
ruby -v 
2.0.0-p0
```

Убедившись, что руби нужный установим сам гем [backup](/meskyanichi/backup) и гем [whenever](/javan/whenever).

```bash
gem install backup
gem install whenever
rbenv rehash
```

Теперь склонируем конфиг

```bash
git clone -b backups git@github.com:evrone/octoshell.git ~/Backups
```

После этого настроим автоматический бекап по крону.

```bash
cd ~/Backup
whenever -w config/shedule.rb
```

Настройки находятся в файлах:

* [models/octoshell_db.rb](https://github.com/evrone/octoshell/blob/backups/models/octoshell_db.rb)
* [models/octoshell_files.rb](https://github.com/evrone/octoshell/blob/backups/models/octoshell_files.rb)
