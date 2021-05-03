using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using TMPro;
using UnityEngine.UI;


public class Manager : MonoBehaviour
{

    public enum ManagerStates
    {
        recording,
        idle,
        playback
    }

    private ManagerStates ManagerState;

    // Start is called before the first frame update
    public Transform rightHand;
    public GameObject BallPrefab;
    private GameObject ball;
    [SerializeField]
    private Animator modelAnimator;
    public float normalizedAnimationTime;
    public List<Section> sections;
    private Section currentSection;
    [SerializeField]
    private float currentSectionMax;
    [SerializeField]
    private float currentSectionMin;

    [SerializeField]
    private bool isCurrentSectionUpwards;
    [SerializeField]
    private float currentStartTime;
    [SerializeField]
    private int currentSectionIndex;
    [SerializeField]
    private int currentLoop = 0;

    // This will be populated in the editor
    public TextMeshProUGUI CurrentStateText;
    public TextMeshProUGUI NumberOfSectionsText;
    public TextMeshProUGUI CurrentSectionText;
    public TextMeshProUGUI CurrentSectionTypeText;
    public TextMeshProUGUI CurrentSectionTimeText;

    public Button RecordingButton;
    public Button PlaybackButton;
    [SerializeField]
    private bool hasFinishedRecording;



    void Start()
    {

        // modify engine speed
        Time.timeScale = 1.0f;


        DOTween.Init();
        ManagerState = ManagerStates.idle;
        RecordingButton.onClick.AddListener(StartRecordingClicked);
        PlaybackButton.onClick.AddListener(StartPlaybackClicked);
        hasFinishedRecording = false;
    }

    private void ToggleAnimation()
    {
        modelAnimator.SetTrigger("Animating");
    }

    private void StartRecordingClicked()
    {
        hasFinishedRecording = false;
        // initialize list of sections
        sections = new List<Section>();
        AnimatorStateInfo animatorStateInfo = modelAnimator.GetCurrentAnimatorStateInfo(0);
        normalizedAnimationTime = animatorStateInfo.normalizedTime;
        currentSectionIndex = 0;
        // Start the animation
        ToggleAnimation();
        // Set current manager state to recording so state machine progresses on
        ManagerState = ManagerStates.recording;
        // Get a reference to the button text component in
        TextMeshProUGUI ButtonText = RecordingButton.GetComponentInChildren<TextMeshProUGUI>();
        // Change button text to recording
        ButtonText.text = "Recording...";
        // disable the buttons (leaving it on screen)
        RecordingButton.interactable = false;
        PlaybackButton.interactable = false;
    }

    private void UpdateCurrentStateText(string newState)
    {
        CurrentStateText.text = "Current State: " + newState;
    }


    private void AddSection(Section newSection)
    {
        sections.Add(newSection);
        NumberOfSectionsText.text = "# Of Sections: " + sections.Count;
    }

    private void StartPlaybackClicked()
    {
        // set state to playback
        ManagerState = ManagerStates.playback;
        TextMeshProUGUI buttonText = PlaybackButton.GetComponentInChildren<TextMeshProUGUI>();
        buttonText.text = "playing...";
        RecordingButton.interactable = false;
        PlaybackButton.interactable = false;
        // null out current section for sanity
        currentSection = null;
        // do initial setup before going to FIRST animation loop, e.g. create ball, set it to the position of the hand
        // Create virtual ball
        ball = Instantiate(BallPrefab);
        // set position of ball to hand position on first frame 
        ball.transform.position = rightHand.position;
        SetCurrentSection(0);
        ToggleAnimation();
    }

    // this function gets called every frame during the recording phase
    private void RecordingPhase()
    {
        if (normalizedAnimationTime >= 1 && !hasFinishedRecording)
        {
            // we have this so we make sure we never come in here twice
            hasFinishedRecording = true;
            ToggleAnimation();
            // we're no longer on the first animation loop
            currentLoop++;
            // Close out last section
            if (!(currentSection is null))
            {
                // set the Y position to be equal to the current right hand y position
                currentSection.endPosition = rightHand.position;
                // set if its an upwards or downards section
                currentSection.isUpwardSection = isCurrentSectionUpwards;
                // set current section's duration 
                currentSection.duration = Time.time - currentStartTime;
                // push the final section into the list
                AddSection(currentSection);

            }

            // Switch back to idle state, enable both buttons now
            RecordingButton.GetComponentInChildren<TextMeshProUGUI>().text = "Start Recording";
            ManagerState = ManagerStates.idle;
            RecordingButton.interactable = true;
            PlaybackButton.interactable = true;
        }
        else
        {
            // this part of the if statement/update loop happens when 
            // the animation loop is definitely still going on
            if (currentSection is null) // this is the beginning of a new section
            {
                // create new section, using starting position as the current right haand y position
                currentSection = new Section() { startPosition = rightHand.position };
                // set max and min positions to the right hand Y position
                currentSectionMax = rightHand.position.y;
                currentSectionMin = rightHand.position.y;
                // set state time to current time
                currentStartTime = Time.time;
            }
            else // we already have a current section, which means this isn't the beginning of a new section
            {

                // set new max and min
                if (rightHand.position.y > currentSectionMax)
                {
                    // set this to be an upwards section
                    isCurrentSectionUpwards = true;
                    // set the current max to the right hand Y position
                    currentSectionMax = rightHand.position.y;
                }
                else if (rightHand.position.y < currentSectionMin)
                {
                    // set this to be a downwards sections
                    isCurrentSectionUpwards = false;
                    // set the current min to the right hand Y position
                    currentSectionMin = rightHand.position.y;
                }

                // start new section if the right hand has changed directions
                if ((isCurrentSectionUpwards && rightHand.position.y < currentSectionMax) || (!isCurrentSectionUpwards && rightHand.position.y > currentSectionMin))
                {
                    // set remaining values in the section object
                    currentSection.isUpwardSection = isCurrentSectionUpwards;
                    // this is technically one frame late but it shouldn't really matter:
                    currentSection.endPosition = rightHand.position;
                    currentSection.duration = Time.time - currentStartTime;
                    // push the current section into the list
                    AddSection(currentSection);
                    // set currentSection to null
                    currentSection = null;
                }

            }

        }
    }

    // returns true if should animate (e.g. this was successful )
    private bool SetCurrentSection(int index)
    {
        bool shouldAnimate = false;
        // Only update the currentSection if the index is in range
        if (sections.Count > index)
        {
            currentStartTime = Time.time;
            currentSectionIndex = index;
            shouldAnimate = true;
            currentSection = sections[index];
            CurrentSectionText.text = $"Current Section: {index}";
            CurrentSectionTypeText.text = $"Section Type: {(currentSection.isUpwardSection ? "up" : "down")}";
        }
        return shouldAnimate;
    }
    // this function gets called every frame during the animation phase
    private void PlaybackPhase()
    {
        // get current loop and compare to stored current loop
        // setup second (and onwards) loops
        // real current loop can be obtained by flooring normalized animation time because the first digit of the normaalized animation time is the amount of times the animation has looped
        // the fractioanl part represents the percentage of the way through the current loop
        int timesPlayed = Mathf.FloorToInt(normalizedAnimationTime);
        // current loop is a number we are creating and managing, where real current loop represents animation loops, so we can increment current loop but shouldnt modify real current loop directly.
        // so, this if statement should happen at the beginning of every animation loop.
        if (timesPlayed >= 1)
        {
            ManagerState = ManagerStates.idle;
            // reset current section to 0 
            SetCurrentSection(0);
            // reset section type text and section time text
            CurrentSectionTypeText.text = "Section Type: ";
            CurrentSectionTimeText.text = "Section Time: ";
            // Destroy the ball
            Destroy(ball);
            // exit the playback phase
            ToggleAnimation();
            PlaybackButton.interactable = true;
            RecordingButton.interactable = true;
            PlaybackButton.GetComponentInChildren<TextMeshProUGUI>().text = "Start Playback";


            currentLoop++;
        }
        else // this only happens while we're in a loop already
        {
            // get total current runtime of current section
            float currentRunningTime = Time.time - currentStartTime;
            // update current time on this section  
            CurrentSectionTimeText.text = $"Section Time: {(int)(currentRunningTime % 1 * 1000)}/{(int)(currentSection.duration % 1 * 1000)} ms";

            // update the current section we are on
            if (currentSection.duration <= currentRunningTime)
            {
                bool shouldAnimate = SetCurrentSection(currentSectionIndex + 1);
                // animate next section
                // if (currentSectionIndex > sections.Count - 2)
                // {
                //     Debug.Log("Overflow");
                // }
                if (shouldAnimate)
                {
                    AnimateSection(currentSectionIndex);
                }

            }
        }
    }

    // Update is called once per frame
    void Update()
    {

        // Get animation normalized time
        AnimatorStateInfo animatorStateInfo = modelAnimator.GetCurrentAnimatorStateInfo(0);
        normalizedAnimationTime = animatorStateInfo.normalizedTime;
        // the integral part of normalized time is the amount of
        // loops the animation has already played
        // we only want to  add sections on first pass of animation,
        // that is, when the normalized time is less then 1

        // state machine
        switch (ManagerState)
        {
            case ManagerStates.idle:
                {
                    UpdateCurrentStateText($"idle");
                    return;
                }
            case ManagerStates.playback:
                {
                    UpdateCurrentStateText($"playback loop {currentLoop - 1} ({(int)(normalizedAnimationTime % 1 * 100)}%)");
                    PlaybackPhase();
                    return;
                }
            case ManagerStates.recording:
                {
                    UpdateCurrentStateText("recording");
                    RecordingPhase();
                    return;
                }
        }
    }

    void AnimateSection(int sectionIndex)
    {
        Section section = sections[sectionIndex];

        if (section.isUpwardSection)
        {
            Vector3 newPos = new Vector3(section.endPosition.x, section.endPosition.y + .5f, section.endPosition.z);
            DOTween.To(() => ball.transform.position, v => ball.transform.position = v, newPos, section.duration);
            // t.DOMove(newPos, section.duration);
            // ball.transform.DOMove(newPos, section.duration);
        }
        else
        {
            Vector3 newPos = new Vector3(section.endPosition.x, section.endPosition.y, section.endPosition.z);
            DOTween.To(() => ball.transform.position, v => ball.transform.position = v, newPos, section.duration);
            // ball.transform.DOMove(newPos, section.duration);
        }

    }
}

public class Section
{
    public Vector3 startPosition;
    public Vector3 endPosition;
    public float duration;
    public bool isUpwardSection;


}