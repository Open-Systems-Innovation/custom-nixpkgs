static char help[] =
    "Example of a description of this program \n";

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Include statements 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
#include <petsc.h>

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   User Context 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
typedef struct {
  /*Example user structure */
} AppCtx;


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Function declarations
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
static PetscErrorCode PLACEHOLDER();

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Main program
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
int main(int argc, char **argv) {

  // declare variables
  AppCtx ctx;  // user program context
  
  // Begin PETSc code
  PetscFunctionBeginUser;
  PetscCall(PetscInitialize(&argc, &argv, NULL, help));

  return 0;
}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Functions
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
// Example function
static PetscErrorCode PLACEHOLDER() {
  PetscFunctionBeginUser;
  // ...
  PetscFunctionReturn(PETSC_SUCCESS);
}
