using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerController : MonoBehaviour
{
    private Rigidbody rb;
    public Button AllOrNothingButton;
    public Text countText, endText, timeText, startCountdownText, LevelCountText;
    public float initialMatchTime = 90.0f;
    public float speed = 10.0f;
    public GameObject Pickups;

    private Text NextLevelButtonText;
    private Vector3 initialPosition;
    private int count;
    private int level;
    private bool gameActive;
    private float startCountdownTimeRemaining;
    private bool countingDownToStart = false;
    private float timeRemaining;
    private bool mustReset = false;


    private void startStartingCountdown()
    {
        gameActive = false;
        startCountdownText.gameObject.SetActive(true);
        // this way we always get a full 3 seconds
        startCountdownTimeRemaining = 3.99f;
        countingDownToStart = true;
        countText.gameObject.SetActive(false);
        timeText.gameObject.SetActive(false);
        setStartCountdown();
    }
    private void setStartCountdown()
    {
        if (startCountdownTimeRemaining < 0) startCountdownTimeRemaining = 0;

        // Make it say go! or the number depending on whats shown
        string countdownString = Mathf.FloorToInt(startCountdownTimeRemaining).ToString();
        countdownString = countdownString == "0" ? "GO!" : countdownString;
        if (countdownString == "3")
        {
            startCountdownText.color = Color.red;
        }
        if (countdownString == "2")
        {
            startCountdownText.color = Color.yellow;
        }
        else if (countdownString == "GO!")
        {
            // change GO! to green
            startCountdownText.color = Color.green;
            // enable player controls and countdown
            gameActive = true;
            // re-enable the timer and score UI
            countText.gameObject.SetActive(true);
            timeText.gameObject.SetActive(true);
        }
        startCountdownText.text = countdownString;
        startCountdownTimeRemaining -= Time.deltaTime;
    }

    void RestoreAllPickups()
    {
        // get reference to all the pickups and loop through them setting them all active
        Transform[] transforms = Pickups.GetComponentsInChildren<Transform>(true);

        for (int i = 0; i < transforms.GetLength(0); i++)
        {
            transforms[i].gameObject.SetActive(true);
        }
    }

    // initial values
    private void ResetGame()
    {
        RestoreAllPickups();
        // must reset should be false at beginning so we're not forced to restart
        mustReset = false;
        // hide end screen if its visible
        toggleEndScreen(false);
        // reset the position of the player to the beginning of the maze
        transform.position = initialPosition;
        // remove forces from the player
        rb.angularVelocity = Vector3.zero;
        rb.velocity = Vector3.zero;
        // initial score/count = 0
        count = 0;
        // set the count text to this initial value
        UpdateCountText();
        // clear the endText
        endText.text = "";
        // Set time remaining to our initial match time, adding a little bit so the first time is visible
        timeRemaining = initialMatchTime + .999f;
        // level modifier starts at 1, this is used to know the multiplier for the timer
        level = 1;
        // Set level counter
        LevelCountText.gameObject.SetActive(true);
        LevelCountText.text = $"Level: {level}";
        // set the game to be counting down to start
        startStartingCountdown();
    }

    void NextLevel()
    {
        level++;
        // Set level counter
        LevelCountText.text = $"Level: {level}";
        // Restore all pickups
        RestoreAllPickups();
        // ensure count and timer are visible
        countText.gameObject.SetActive(true);
        timeText.gameObject.SetActive(true);
        // hide the end screen
        endText.text = "";
        toggleEndScreen(false);

        // remove forces from the player
        rb.angularVelocity = Vector3.zero;
        rb.velocity = Vector3.zero;

        // Set remaining time to appropriate time for level, adding a little bit so the first number is visible
        timeRemaining = getLevelTime() + .99f;

        // reset the position of the player
        transform.position = initialPosition;

        // start the countdown timer
        startStartingCountdown();
    }

    private void Start()
    {
        // Store players initial position from the unity editor
        initialPosition = transform.position;
        // get reference to next level button text
        NextLevelButtonText = AllOrNothingButton.GetComponentInChildren<Text>();
        // get reference to the rigid body
        rb = GetComponent<Rigidbody>();
        // Describe what method to call when all or nothing button is clicked
        AllOrNothingButton.onClick.AddListener(AllOrNothingClicked);

        // Set game up
        ResetGame();
    }
    private void Update()
    {
        // do nothing if the game isn't active
        if (gameActive)
        {
            // update timer
            setTimer();

            if (timeRemaining <= 0)
            {
                // if we have no remaining time we lose
                loseGame();
            }
        }
        if (countingDownToStart)
        {
            setStartCountdown();
            if (startCountdownTimeRemaining <= 0)
            {
                countingDownToStart = false;
                startCountdownText.gameObject.SetActive(false);
            }
        }
    }
    void FixedUpdate()
    {
        // Don't allow movement if the game isn't active
        if (gameActive)
        {
            // get the input from Unity Input Manager
            float moveHorizontal = Input.GetAxis("Horizontal");
            float moveVertical = Input.GetAxis("Vertical");
            Vector3 movement = new Vector3(moveHorizontal, 0.0f, moveVertical);
            // Multiply by scalar speed to make our movements faster
            rb.AddForce(speed * movement);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Pick Up"))
        {
            // hide the pick up
            other.gameObject.SetActive(false);
            // increase the score
            count += 1;
            // update the text displaying the score
            UpdateCountText();
        }
        else if (other.CompareTag("Exit"))
        {
            // set the game to inactive
            gameActive = false;
            // show the end game screen
            showEndScreen(true);
        }
    }

    void UpdateCountText()
    {
        // Update the count text in the HUD to the current score
        countText.text = $"Count: {count}";
    }

    void loseGame()
    {
        // set game to inactive, show the end screen
        gameActive = false;
        showEndScreen(false);
        mustReset = true;
    }

    void setTimer()
    {
        // Reduce time remaining by the time since last frame ( in seconds ) 
        timeRemaining -= Time.deltaTime;
        // never go below 0 seconds
        if (timeRemaining < 0) timeRemaining = 0;

        timeText.text = Mathf.FloorToInt(timeRemaining).ToString();
        float currentLevelTime = getLevelTime();
        // if we have less than 2/3 of the remaining time change countdown to yellow
        if (timeRemaining <= currentLevelTime * 2 / 3)
        {
            timeText.color = Color.yellow;
        }
        // if we have less than a third of the remaining time change countdown to red
        if (timeRemaining <= currentLevelTime / 3)
        {
            timeText.color = Color.red;
        }
    }

    float getLevelTime()
    {
        // level 1 == initialMatchTime * 3/3 
        // level 2 == initialMatchTime * 2/3
        // level 3 == initialMatchTime * 1/3
        float levelTime = initialMatchTime * (4 - level) / 3;
        return levelTime;
    }

    void showEndScreen(bool win)
    {

        // hide the Count and timer
        countText.gameObject.SetActive(false);
        timeText.gameObject.SetActive(false);
        // Create win and lose strings
        string winString = $"Score: {count}";
        string loseString = $"You lose! Score: 0";

        // Hide the all or nothing button when the player has beaten the game
        if (level >= 3 && win)
        {
            winString = $"You win! Score: {count}";
            mustReset = true;
        }
        if (mustReset)
        {
            NextLevelButtonText.text = "Play again?";
        }
        else
        {
            NextLevelButtonText.text = "All or Nothing?";
        }

        // Decide which string to show
        endText.text = win ? winString : loseString;


        // Unhide the gameobject that holds the panel and the end text
        toggleEndScreen(true);

    }

    // only used to turn it on or off, showEndScreen method should be used when advancing to that screen
    void toggleEndScreen(bool show)
    {
        endText.transform.parent.gameObject.SetActive(show);

    }

    void AllOrNothingClicked()
    {
        if (mustReset)
        {
            ResetGame();
        }
        else
        {
            NextLevel();
        }
    }
}
