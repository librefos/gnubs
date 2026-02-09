
/*
 * $PKG_NAME - $PKG_DESCRIPTION
 * Copyright (C) $COPYRIGHT_YEAR $AUTHOR_NAME
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

#include <config.h>
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>

/* Gnulib modules */
#include "progname.h"
#include "version-etc.h"

/* Required by the 'version-etc' module. */
const char version_etc_copyright[] =
  "Copyright (C) $COPYRIGHT_YEAR $AUTHOR_NAME";

#define PACKAGE_BUGREPORT_ADDRESS "$AUTHOR_EMAIL"

static void
usage (int status)
{
  if (status != EXIT_SUCCESS)
    {
      fprintf (stderr, "Try '%s --help' for more information.\n",
               program_name);
    }
  else
    {
      printf ("Usage: %s [OPTION]...\n", program_name);
      printf ("$PKG_DESCRIPTION\n\n");

      fputs ("      --help     display this help and exit\n", stdout);
      fputs ("      --version  output version information and exit\n", stdout);

      emit_bug_reporting_address ();
    }
  exit (status);
}

int
main (int argc, char *argv[])
{
  int c;
  int option_index = 0;

  static struct option long_options[] =
    {
      {"help", no_argument, 0, 'h'},
      {"version", no_argument, 0, 'v'},
      {0, 0, 0, 0}
    };

  set_program_name (argv[0]);

  while (1)
    {
      c = getopt_long (argc, argv, "hv", long_options, &option_index);

      if (c == -1)
        break;

      switch (c)
        {
        case 'h':
          usage (EXIT_SUCCESS);
          break;

        case 'v':
          version_etc (stdout, "$PKG_TARNAME", "$PKG_NAME", "$PKG_VERSION",
                       "$AUTHOR_NAME", (char *) NULL);
          exit (EXIT_SUCCESS);
          break;

        case '?':
          usage (EXIT_FAILURE);
          break;

        default:
          abort ();
        }
    }

  printf ("hello, $PKG_TARNAME\n");
  return EXIT_SUCCESS;
}

