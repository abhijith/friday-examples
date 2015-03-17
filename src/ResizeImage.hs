{-# LANGUAGE ScopedTypeVariables #-}
import System.Environment (getArgs)

import Vision.Image
import Vision.Image.Storage.DevIL (Autodetect (..), load, save)
import Vision.Primitive (ix2)
import Data.List.Split as Split


-- Resizes the input image to a square of 250x250 pixels.
--
-- usage: ./resize_image input.png output.png dimension
main :: IO ()
main = do
    [input, output, dimension] <- getArgs

    -- Loads the image. Automatically infers the format.
    io <- load Autodetect input

    case io of
        Left err           -> do
            putStrLn "Unable to load the image:"
            print err
        Right (rgb :: RGB) -> do
            let -- Resizes the RGB image to 250x250 pixels.
                [width, height] = Split.splitOn "x" dimension
                w = Prelude.read width :: Int
                h = Prelude.read height :: Int
                resized = resize Bilinear (ix2 w h) rgb :: RGB

            -- Saves the resized image. Automatically infers the output format.
            mErr <- save Autodetect output resized
            case mErr of
                Nothing  ->
                    putStrLn "Success."
                Just err -> do
                    putStrLn "Unable to save the image:"
                    print err
