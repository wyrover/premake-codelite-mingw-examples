#include <Windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>


#define VERSION "1.0.2"
#define ARGUMENTS "hvabc:d:f:"

void showHelp();

int main(int argc, char** argv)
{
    SetConsoleOutputCP(65001);
    printf("中文测试\n");
    static int verbose_flag;
    int c;
    static struct option long_options[] = {
        {"verbose", no_argument, &verbose_flag, 1},
        {"brief",   no_argument, &verbose_flag, 0},
        {"add",     no_argument, 0, 'a'},
        {"append",  no_argument, 0, 'b'},
        {"delete",  required_argument,  0, 'd'},
        {"create",  required_argument,  0, 'c'},
        {"file",    required_argument, 0 , 'f'},
        {"version", required_argument, 0 , 'v'},
        {"help",    required_argument, 0 , 'h'},
        { NULL , no_argument , NULL , no_argument }
    };

    while (1) {
        int option_index = 0;
        c = getopt_long(argc, argv, ARGUMENTS, long_options, &option_index);

        // Check for end of operation or error
        if (c == -1 || c == '?')
            break;

        // Handle options
        switch (c) {
        case 0:

            /* If this option set a flag, do nothing else now. */
            if (long_options[option_index].flag != 0)
                break;

            printf("option %s", long_options[option_index].name);

            if (optarg)
                printf(" with arg %s", optarg);

            printf("\n");
            break;

        case 'a':
            printf("option -a\n");
            break;

        case 'b':
            printf("option -b\n");
            break;

        case 'c':
            printf("option -c with value `%s'\n", optarg);
            break;

        case 'd':
            printf("option -d with value `%s'\n", optarg);
            break;

        case 'f':
            printf("option -f with value `%s'\n", optarg);
            break;

        case 'v':
            printf(VERSION);
            break;

        case 'h':
            showHelp();
            break;

        default:
            showHelp();
            break;
        }
    }

    if (verbose_flag)
        printf("verbose flag is set\n");

    if (optind < argc) {
        printf("non-option ARGV-elements: ");

        while (optind < argc) printf("%s ", argv[optind++]);

        printf("\n");
    }

    return 0;
}

void showHelp()
{
    printf("Snappy Test %s\n\n", VERSION);
    printf("Usage: snappytest <options> <filename>\n\n");
    printf("Options:\n");
    printf("     -c  Compress a file\n");
    printf("     -x  Extract a file\n\n");
    printf("Example:\n");
    printf("  snappytest -c logo.bmp\n");
    exit(0);
}