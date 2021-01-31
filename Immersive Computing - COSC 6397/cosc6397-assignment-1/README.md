# Homework 1 for COSC 6397

Author: Michael McQuade

## Objective

Create a roll-a-ball style game where the player is a ball and can collect points by colliding with floating objectives. Utilize the Vuforia SDK and an image target to place the game into the real world. Deploy this to a device (iOS/android).

## Attributions

The dogecoin model was obtained for free from [TurboSquid](https://www.turbosquid.com/3d-models/free-max-mode-doge-coin/787687), created by user MACHIN3D

The coin sound is a free sound from the [GDC yearly giveaway pack](https://sonniss.com/gameaudiogdc).

The live dogecoin price is coming from a microservice I created for this project. I didnt't want to embed API credentials into my Unity app so I made a small wrapper around [CoinMarketCap](https://coinmarketcap.com/api/documentation/v1/)'s API and deployed it using [Vercel](https://vercel.com). You can see the full code in the other [repo here](https://github.com/giraffesyo/dogecoin). It's live at https://dogecoin.giraffesyo.dev/api and does not require an api key. In order to prevent hammering CoinMarketCap's API I'm using `Cache-Control` headers with `s-maxage` which causes Vercel's CDN to cache responses for the length specified by `s-maxage`. In this case, responses are cached for 5 minutes.
