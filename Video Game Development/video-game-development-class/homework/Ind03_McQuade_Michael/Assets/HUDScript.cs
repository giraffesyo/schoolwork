using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HUDScript : MonoBehaviour
{
    // start off with 0
    private int score = 0;
    // start with 2 mins (120s)
    private float remainingTime;
    // Create variables for our canvas UI elements
    public Text ScoreText;
    public Text TimeText;

    private void Restart()
    {
        // set variables, we use 120.99 so that 2 minutes shows but not 2:01
        remainingTime = 120.99f;
        score = 0;
        // reset labels 
        ScoreText.text = "Score: 0";
        TimeText.text = "2:00";
    }


    private void Start()
    {
        //start the game 
        Restart();
    }

    // Update is called once per frame
    void Update()
    {
        // restart the game
        if (remainingTime < 0.1f)
        {
            Restart();
        }
        else
        {

            decrementTime(Time.deltaTime);
        }
    }

    public void incrementScore()
    {
        score++;
        ScoreText.text = $"Score: {score}";
    }

    private void decrementTime(float timePassed)
    {

        // remove time passed from the remaining time
        remainingTime -= timePassed;
        // get minutes and seconds from remainingTime
        int minutes = Mathf.FloorToInt(remainingTime / 60.0f);
        int seconds = Mathf.FloorToInt(remainingTime % 60.0f);
        string timeToDisplay;
        if (minutes == 0)
        {
            // just show seconds if we have no minutes
            timeToDisplay = seconds.ToString();
        }
        else
        {
            // prefix leading 0 in case we have less than 10 seconds
            string secondsString = seconds < 10 ? $"0{seconds}" : seconds.ToString();
            // separate minutes and seconds by colon
            timeToDisplay = $"{minutes}:{secondsString}";
        }
        // set label equal to the string we just made (probably purify this method later so it just returns the string)
        TimeText.text = timeToDisplay;
    }


}
