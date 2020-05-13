# navigstion

## Project setup
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Lints and fixes files
```
npm run lint
```


### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).

### for aws
``` 
Запусть на новом сервере:
```
cd ~ &&
git clone https://github.com/Akinoriv/vkr.git && 
cd vkr && 
sudo npm install &&  ## if killed  
  sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
  sudo /sbin/mkswap /var/swap.1
  sudo /sbin/swapon /var/swap.1
npm run build && 
// npm run serve ## заменить для вечной жизни на -> 
sudo forever start -c 'serve' dist
```

Запустить обновления:
```
cd vkr
git pull
forever stopall (убили все циклы)
sudo npm run build 
sudo forever start -c 'serve' dist
```
