redis-subscribe-exit
===================
A simple python script and docker container for pushing exit codes via pubsub. Useful for doing mutex-type operations in parallel drone pipelines.


### Testing and Example Usage
You can run something like this with a redis running on your local machine:
```bash
docker run -e REDIS_URL=redis://host.docker.internal -e REDIS_CHANNEL=test daxxog/redis-subscribe-exit
```

And then in another terminal, push an exit code:
```bash
redis-cli PUBLISH test 2
```
