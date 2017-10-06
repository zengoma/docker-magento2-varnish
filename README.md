## Magento 2 Varnish4 Cache
A simple varnish 4 cache for Magento 2. This varnish cache works well with my
[magento2 dev container](https://hub.docker.com/r/zengoma/magento2-apache-dev/).

### Using the cache
Minimal setup only requires that you bind port 80 to the host and that you name
your magento2 container "magento2" or link it to magento2 in the varnish container.

docker-compose example:

```yaml
version: "3"
services:

  varnish:
    depends_on:
      - magento2-dev
    image: magento2-varnish
    ports:
      - "80:80"
    links:
      - magento2-dev:magento2

  # Your magento 2 container goes here
```

### Configure Magento 2 to use Varnish4
The following steps are required to ensure magento can use and purge the varnish cache:

* Log in to the Magento Admin as an administrator.
* Click STORES > Configuration > ADVANCED > System > Full Page Cache.
* From the Caching Application list, click Varnish Caching.
* Enter a value in the TTL for public content field.
* You do not need to fill in or export any configuration details.

Alternatively you can run the following command on your database container to enable the cache:

```bash
docker-compose exec db sh mysqld -u $MYSQL_USER -p"${MYSQL_PASSWORD}" -D $MYSQL_DATABASE -e \
"INSERT INTO core_config_data ( scope, scope_id, path, value ) VALUES \
( 'default', '0', 'system/full_page_cache/caching_application', '2') \
ON DUPLICATE KEY UPDATE value = 2;"
```
_Where "db" is the name of the database container_

### Default variables

* VARNISH_PORT 80
* VARNISH_BACKEND 80

There are only two configurable variables, there is no need to really change these
unless you have configured magento to listen on a different port or you want to serve
varnish content on a port other than 80.
