static char help[] =
    "Example of a description of this program \n";

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Include statements 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
#include <petscdmplex.h>

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   User Context 
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
typedef struct {
  /*Example user structure */
  char     infile[PETSC_MAX_PATH_LEN];  /* Input mesh filename */
  char     outfile[PETSC_MAX_PATH_LEN]; /* Dump/reload mesh filename */
} AppCtx;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Function declarations
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
static PetscErrorCode ProcessOptions(MPI_Comm comm, AppCtx *options);
static PetscErrorCode PLACEHOLDER();

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Main program
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
int main(int argc, char **argv) {

  // Declare variables
  AppCtx ctx;  // user program context
  DM     dm;   // mesh data managment

  // Initialize PETSc code
  PetscFunctionBeginUser;
  PetscCall(PetscInitialize(&argc, &argv, NULL, help));
  
  // Set default user-defined parameters
  PetscStrcpy(ctx.infile, "input.gmsh");
  PetscStrcpy(ctx.outfile, "output.vtk");

  // Process user options
  ProcessOptions(PETSC_COMM_WORLD, &ctx);
  
  // Read in 3D mesh from file
  PetscCall(DMPlexCreateFromFile(PETSC_COMM_WORLD, ctx.infile, NULL, PETSC_TRUE,
                                 &dm));

  // Create finite element
   
  // Create timestepping solver context

  // Set initial conditions

  // Set boundary conditions

  // Run solver

  // View results
  PetscViewer viewer;
  PetscViewerVTKOpen(PETSC_COMM_WORLD, ctx.outfile, FILE_MODE_WRITE, &viewer);
  DMPlexView(dm, viewer);
  PetscViewerDestroy(&viewer);

  // Free objects from memory
  
  // End main program
  PetscFinalize();
  return 0;
}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Functions
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
static PetscErrorCode ProcessOptions(MPI_Comm comm, AppCtx *options)
{
  PetscBool flg;

  PetscFunctionBeginUser;
  
  PetscOptionsBegin(comm, "", "My Project's Options", "DMPLEX");

  // get the input file name
  PetscCall(PetscOptionsString("-infile", "The input mesh file", "",
                               options->infile, options->infile,
                               sizeof(options->infile), &flg));
  // check if it was successfully passed as an argument
  PetscCheck(flg, comm, PETSC_ERR_USER_INPUT, "-infile needs to be specified");

  // get the output file name
  PetscCall(PetscOptionsString("-outfile", "The output mesh file", "",
                               options->outfile, options->outfile,
                               sizeof(options->outfile), &flg));
  // check if it was sucessfully passed as an argument
  PetscCheck(flg, comm, PETSC_ERR_USER_INPUT, "-outfile needs to be specified");

  // End function
  PetscOptionsEnd();
  PetscFunctionReturn(PETSC_SUCCESS);
}


// Example function
static PetscErrorCode PLACEHOLDER() {
  PetscFunctionBeginUser;
  // ...
  PetscFunctionReturn(PETSC_SUCCESS);
}
