{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchurl,
  python3,
  blas,
  lapack,
  mpi,
  openssh, # required for openmpi tests
  buildEnv,
  petsc-optimized ? false,
  petsc-scalar-type ? "real",
  petsc-precision ? "double",
  with64BitIndices ? false,
 # withP4est ? false,
 # p4est,
 # zlib, # propagated by p4est but required by petsc
  withHdf5 ? true,
  hdf5-mpi,
 # hdf5,
  withPtscotch ? true,
  scotch,
 # withSuperlu ? false,
 # superlu,
 # withHypre ? false,
 # hypre,
 # withScalapack ? false,
 # scalapack,
 # withMumps ? false,
 # withChaco ? true,
 # buildEnv,
 # breakpointHook,
}:

let
  # get the paths for blas and lapack for compilation config
  blaslapack = buildEnv {
    name = "blaslapack-${blas.version}+${lapack.version}";
    paths = [
      (lib.getLib blas)
      (lib.getDev blas)
      (lib.getLib lapack)
      (lib.getDev lapack)
    ];
  };

  # function to simplify adding libraries to compilation config
  withLibrary =
    name: pkg: enable:
    let
      combinedPkg = buildEnv {
        name = "${pkg.name}-combined";
        paths = [
          (lib.getLib pkg)
          (lib.getDev pkg)
        ];
      };
    in
    ''
      "--with-${name}=${if enable then "1" else "0"}"
      ${lib.optionalString enable ''
        "--with-${name}-dir=${combinedPkg}"
      ''}
    '';

  hdf5 = (hdf5-mpi.override { inherit mpi; });

  scotch' =
  (scotch.override {
    inherit mpi;
    #withIntSize64 = with64BitIndices;
  }).overrideAttrs
    (attrs: {
      buildFlags = [ "ptesmumps esmumps" ];
    });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "petsc";
  version = "3.22.1";

  src = fetchFromGitLab {
    owner = "petsc";
    repo = "petsc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8Ee1uXyj38lVWL/niTmSdmBalXSvsdHL2edUGgLjE9Y=";
  };

  #inherit mpiSupport;

  strictDeps = true;

  nativeBuildInputs = [
    python3
    mpi
    openssh
  ];

  SCOTCH_DIR = "${scotch'}/";

  nativeCheckInputs = [ openssh mpi ];
  # Both OpenMPI and MPICH get confused by the sandbox environment and spew errors like this (both to stdout and stderr):
  #     [hwloc/linux] failed to find sysfs cpu topology directory, aborting linux discovery.
  #     [1684747490.391106] [localhost:14258:0]       tcp_iface.c:837  UCX  ERROR scandir(/sys/class/net) failed: No such file or directory
  # These messages contaminate test output, which makes the quicktest suite to fail. The patch adds filtering for these messages.
  patches = [ ./filter_mpi_warnings.patch ];

    #export PATH=${openssh}/bin:$PATH
    #export OMPI_MCA_plm_rsh_agent=${openssh}/bin/ssh
  preConfigure = ''
    patchShebangs ./configure ./lib/petsc/bin
    configureFlagsArray+=(
      "--with-cc=mpicc"
      "--with-cxx=mpicxx"
      "--with-fc=0"

      "--with-scalar-type=${petsc-scalar-type}"
      "--with-precision=${petsc-precision}"
      "--with-64-bit-indices=${if with64BitIndices then "1" else "0"}"

      ${withLibrary "blaslapack" blaslapack true}
      ${withLibrary "hdf5" hdf5 withHdf5}
      ${withLibrary "ptscotch" scotch' withPtscotch}

      ${lib.optionalString petsc-optimized ''
          "--with-debugging=0"
          COPTFLAGS='-g -O3'
          FOPTFLAGS='-g -O3'
          CXXOPTFLAGS='-g -O3'
        ''}
      )
  '';
  
  configureScript = "python ./configure";

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/src
    cp -r $src/src $out
    make install
  '';

  # only run tests after they have been placed into $out
  # workaround for `cannot find -lpetsc: No such file or directory`
  doCheck = false;
  doInstallCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  installCheckTarget = "check";

  meta = {
    description = "Portable Extensible Toolkit for Scientific computation";
    homepage = "https://www.mcs.anl.gov/petsc/index.html";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      Open-Systems-Innovation
    ];
  };
})
