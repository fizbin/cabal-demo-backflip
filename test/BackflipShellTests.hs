import Data.List (isSuffixOf)
import Control.Applicative
import Test.Framework (defaultMain, testGroup, Test)
import Test.Framework.Providers.HUnit
import Test.HUnit (assertFailure)
import System.Directory
import System.Exit (ExitCode(..))
import System.Process


main :: IO ()
main = makeTests "test" >>= defaultMain

-- Make a test out of those things which end in ".sh" and are executable
-- Make a testgroup out of directories
makeTests :: FilePath -> IO [Test]
makeTests dir = do
  origDir <- getCurrentDirectory
  contents <- getDirectoryContents dir
  setCurrentDirectory dir
  retval <- mapM fileFunc contents
  setCurrentDirectory origDir
  return $ concat retval
  where
    fileFunc "." = return []
    fileFunc ".." = return []
    fileFunc f | ".sh" `isSuffixOf` f = do
      fullName <- canonicalizePath f
      isExecutable <- executable <$> getPermissions fullName
      let hunitTest = mkTest fullName
      return [testCase f hunitTest | isExecutable]
    fileFunc d = do
      fullName <- canonicalizePath d
      isSearchable <- searchable <$> getPermissions fullName
      if isSearchable
        then do subTests <- makeTests d
                return [testGroup d subTests]
        else return []
    mkTest fullName = do
      execResult <- system fullName
      case execResult of
        ExitSuccess -> return ()
        ExitFailure code -> assertFailure ("Failed with code " ++ show code)
