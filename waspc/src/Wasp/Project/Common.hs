module Wasp.Project.Common
  ( WaspProjectDir,
    DotWaspDir,
    NodeModulesDir,
    CompileError,
    CompileWarning,
    PackageJsonFile,
    TsConfigFile,
    findFileInWaspProjectDir,
    dotWaspDirInWaspProjectDir,
    generatedCodeDirInDotWaspDir,
    buildDirInDotWaspDir,
    waspProjectDirFromProjectRootDir,
    dotWaspRootFileInWaspProjectDir,
    dotWaspInfoFileInGeneratedCodeDir,
    packageJsonInWaspProjectDir,
    packageLockJsonInWaspProjectDir,
    nodeModulesDirInWaspProjectDir,
    srcDirInWaspProjectDir,
    extPublicDirInWaspProjectDir,
    tsconfigInWaspProjectDir,
    prismaSchemaFileInWaspProjectDir,
    tsConfigInWaspProjectDir,
  )
where

import StrongPath (Abs, Dir, File, File', Path', Rel, reldir, relfile, toFilePath, (</>))
import System.Directory (doesFileExist)
import Wasp.AppSpec.ExternalFiles (SourceExternalCodeDir, SourceExternalPublicDir)
import qualified Wasp.Generator.Common

type CompileError = String

type CompileWarning = String

data WaspProjectDir -- Root dir of Wasp project, containing source files.

data NodeModulesDir

data DotWaspDir -- Here we put everything that wasp generates.

data PackageJsonFile

data TsConfigFile

-- | NOTE: If you change the depth of this path, also update @waspProjectDirFromProjectRootDir@ below.
-- TODO: SHould this be renamed to include word "root"?
dotWaspDirInWaspProjectDir :: Path' (Rel WaspProjectDir) (Dir DotWaspDir)
dotWaspDirInWaspProjectDir = [reldir|.wasp|]

nodeModulesDirInWaspProjectDir :: Path' (Rel WaspProjectDir) (Dir NodeModulesDir)
nodeModulesDirInWaspProjectDir = [reldir|node_modules|]

-- | NOTE: If you change the depth of this path, also update @waspProjectDirFromProjectRootDir@ below.
-- TODO: Hm this has different name than it has in Generator.
generatedCodeDirInDotWaspDir :: Path' (Rel DotWaspDir) (Dir Wasp.Generator.Common.ProjectRootDir)
generatedCodeDirInDotWaspDir = [reldir|out|]

-- | NOTE: If you change the depth of this path, also update @waspProjectDirFromProjectRootDir@ below.
buildDirInDotWaspDir :: Path' (Rel DotWaspDir) (Dir Wasp.Generator.Common.ProjectRootDir)
buildDirInDotWaspDir = [reldir|build|]

-- | NOTE: This path is calculated from the values of @dotWaspDirInWaspProjectDir@,
-- @generatedCodeDirInDotWaspDir@ and @buildDirInDotWaspDir@., which are the three functions just above.
-- Also, it assumes @generatedCodeDirInDotWaspDir@ and @buildDirInDotWaspDir@ have same depth.
-- If any of those change significantly (their depth), this path should be adjusted.
waspProjectDirFromProjectRootDir :: Path' (Rel Wasp.Generator.Common.ProjectRootDir) (Dir WaspProjectDir)
waspProjectDirFromProjectRootDir = [reldir|../../|]

dotWaspRootFileInWaspProjectDir :: Path' (Rel WaspProjectDir) File'
dotWaspRootFileInWaspProjectDir = [relfile|.wasproot|]

dotWaspInfoFileInGeneratedCodeDir :: Path' (Rel Wasp.Generator.Common.ProjectRootDir) File'
dotWaspInfoFileInGeneratedCodeDir = [relfile|.waspinfo|]

packageJsonInWaspProjectDir :: Path' (Rel WaspProjectDir) (File PackageJsonFile)
packageJsonInWaspProjectDir = [relfile|package.json|]

tsConfigInWaspProjectDir :: Path' (Rel WaspProjectDir) (File TsConfigFile)
tsConfigInWaspProjectDir = [relfile|tsconfig.json|]

packageLockJsonInWaspProjectDir :: Path' (Rel WaspProjectDir) File'
packageLockJsonInWaspProjectDir = [relfile|package-lock.json|]

prismaSchemaFileInWaspProjectDir :: Path' (Rel WaspProjectDir) File'
prismaSchemaFileInWaspProjectDir = [relfile|schema.prisma|]

srcDirInWaspProjectDir :: Path' (Rel WaspProjectDir) (Dir SourceExternalCodeDir)
srcDirInWaspProjectDir = [reldir|src|]

extPublicDirInWaspProjectDir :: Path' (Rel WaspProjectDir) (Dir SourceExternalPublicDir)
extPublicDirInWaspProjectDir = [reldir|public|]

tsconfigInWaspProjectDir :: Path' (Rel WaspProjectDir) File'
tsconfigInWaspProjectDir = [relfile|tsconfig.json|]

findFileInWaspProjectDir ::
  Path' Abs (Dir WaspProjectDir) ->
  Path' (Rel WaspProjectDir) (File file) ->
  IO (Maybe (Path' Abs (File file)))
findFileInWaspProjectDir waspDir file = do
  let fileAbsFp = waspDir </> file
  fileExists <- doesFileExist $ toFilePath fileAbsFp
  return $ if fileExists then Just fileAbsFp else Nothing
