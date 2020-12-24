h1$ vi mutex.c
#include <sys/types.h>
#include <err.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

struct worker_args {
        int     num;
        size_t  size;
};

void* get_common_buffer(size_t minsize) {
        static void *buf = NULL, *t, *t2;
        static size_t cursz = 0;
        static pthread_mutex_t bufmtx = PTHREAD_MUTEX_INITIALIZER;

        if (minsize > cursz) {
                if ((t = malloc(minsize)) == NULL)
                        return NULL;
                pthread_mutex_lock(&bufmtx);
                t2 = buf;
                buf = t;
                cursz = minsize;
                free(t2);
                pthread_mutex_unlock(&bufmtx);
        }
        return buf;
}

void* worker(void *data) {
        struct worker_args *args = data;
        //struct worker_args wa = *args;
        void *buf;
        FILE *f;

        if ((buf = get_common_buffer(args->size)) == NULL)
                err(1, "worker %d", args->num);
        //
        //
        //arc4random_buf(buf, args->size);
        char str[10] = "file_.dat";
        str[4] = (char)args->num + '0';
        //printf("num %d\n", wa.num);
        if ((f = fopen(fl, "w")) == NULL)       // 
                err(1, "worker %d: fopen", args->num);
        if (fwrite(buf, 1, args->size, f) < args->size)
                err(1, "worker %d: fwrite", args->num);
        fclose(f);
        fprintf(stderr, "The file file%d.dat is written successfully.\n", args->num);
        return NULL;
}

int main(int argc, char *argv[]) {
        int i, terr;
        pthread_t threads[argc-1];
        struct worker_args args[argc-1]; // 
        char *ep;

        for (i = 1; i < argc; i++) {
                //printf("i = %d\n", i);
                args[i-1].num = i;
                args[i-1].size = (size_t)strtoul(argv[i], &ep, 10);
                if (!argv[i][0] && *ep)
                        err(1, "invalid size spec #%d: %s", i, argv[i]);
                terr = pthread_create(&threads[i-1], NULL, &worker, &args[i-1]);
                if (terr)
                        err(1, "pthread_create for worker %d", i);
        }
        for (i = 1; i < argc; i++)
                pthread_join(threads[i-1], NULL);
        return 0;
}
