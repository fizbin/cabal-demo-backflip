import Fizbin.Test.Backflip
import System.Environment (getArgs)
import Control.Monad (liftM)

main :: IO ()
main = liftM backflip getArgs >>= mapM_ putStrLn
