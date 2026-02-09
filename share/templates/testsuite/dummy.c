
/* dummy - Dummy test program.
 * Copyright (C) $COPYRIGHT_YEAR  $AUTHOR_NAME
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
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <config.h>
#include <stdio.h>
#include <assert.h>

#include "version-etc.h"

const char version_etc_copyright[] = "Test Copyright";

int
main (void)
{
  printf ("Running unit tests...\n");

  /* Sanity Check: Ensure the copyright string linked correctly. If the
     pointer is NULL, the linkage is broken */
  if (version_etc_copyright == NULL) return 1;

  /* Unit Test Assertion: In a real test, this would call specific
   * functions from the library being tested. */
  assert (1 + 1 == 2);

  return 0;
}

