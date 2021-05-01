using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using TMPro;

public class Manager : MonoBehaviour
{
    // Start is called before the first frame update
    public Transform rightHand;
    [SerializeField]
    private float RightHandYPosition;
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


    void Start()
    {
        // initialize list of sections
        sections = new List<Section>();
        // Get current hand position
        UpdateRightHandPosition();

        // modify engine speed
        Time.timeScale = 1.0f;
        // BallScript ballScript = GetComponent<BallScript>();
        // ballScript.Target = rightHand.transform;
        // ballScript.Projectile = ball.transform;
        // StartCoroutine(ballScript.SimulateProjectile());
        AnimatorStateInfo animatorStateInfo = modelAnimator.GetCurrentAnimatorStateInfo(0);
        normalizedAnimationTime = animatorStateInfo.normalizedTime;
        currentSectionIndex = 0;
        DOTween.Init();



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


    // this function gets called every frame during the recording phase
    private void RecordingPhase()
    {
        if (normalizedAnimationTime >= 1)
        {
            // we're no longer on the first animation loop
            currentLoop++;
            // Close out last section
            // set the Y position to be equal to the current right hand y position
            currentSection.endYPosition = RightHandYPosition;
            // set if its an upwards or downards section
            currentSection.isUpwardSection = isCurrentSectionUpwards;
            // set current section's duration 
            currentSection.duration = Time.time - currentStartTime;
            // push the final section into the list
            AddSection(currentSection);
            // null out current section for sanity
            currentSection = null;

            // do initial setup before going to FIRST animation loop, e.g. create ball, set it to the position of the hand
            // Create virtual ball
            ball = Instantiate(BallPrefab);
            // set position of ball to hand position
            ball.transform.position = rightHand.position;

        }
        else
        {
            // this part of the if statement/update loop happens when 
            // the animation loop is definitely still going on
            if (currentSection is null) // this is the beginning of a new section
            {
                // create new section, using starting position as the current right haand y position
                currentSection = new Section() { startYPosition = RightHandYPosition };
                // set max and min positions to the right hand Y position
                currentSectionMax = RightHandYPosition;
                currentSectionMin = RightHandYPosition;
                // set state time to current time
                currentStartTime = Time.time;
            }
            else // we already have a current section, which means this isn't the beginning of a new section
            {

                // set new max and min
                if (RightHandYPosition > currentSectionMax)
                {
                    // set this to be an upwards section
                    isCurrentSectionUpwards = true;
                    // set the current max to the right hand Y position
                    currentSectionMax = RightHandYPosition;
                }
                else if (RightHandYPosition < currentSectionMin)
                {
                    // set this to be a downwards sections
                    isCurrentSectionUpwards = false;
                    // set the current min to the right hand Y position
                    currentSectionMin = RightHandYPosition;
                }

                // start new section if the right hand has changed directions
                if ((isCurrentSectionUpwards && RightHandYPosition < currentSectionMax) || (!isCurrentSectionUpwards && RightHandYPosition > currentSectionMin))
                {
                    // set remaining values in the section object
                    currentSection.isUpwardSection = isCurrentSectionUpwards;
                    // this is technically one frame late but it shouldn't really matter:
                    currentSection.endYPosition = RightHandYPosition;
                    currentSection.duration = Time.time - currentStartTime;
                    // push the current section into the list
                    AddSection(currentSection);
                    // set currentSection to null
                    currentSection = null;
                }

            }

        }
    }

    private void SetCurrentSection(int index)
    {
        currentStartTime = Time.time;
        currentSectionIndex = index;
        currentSection = sections[index];
        CurrentSectionText.text = $"Current Section: {index}";
        CurrentSectionTypeText.text = $"Section Type: {(currentSection.isUpwardSection ? "up" : "down")}";

    }
    // this function gets called every frame during the animation phase
    private void PlaybackPhase()
    {
        // get current loop and compare to stored current loop
        // setup second (and onwards) loops
        // real current loop can be obtained by flooring normalized animation time because the first digit of the normaalized animation time is the amount of times the animation has looped
        // the fractioanl part represents the percentage of the way through the current loop
        int realCurrentLoop = Mathf.FloorToInt(normalizedAnimationTime);
        // current loop is a number we are creating and managing, where real current loop represents animation loops, so we can increment current loop but shouldnt modify real current loop directly.
        // so, this if statement should happen at the beginning of every animation loop.
        if (realCurrentLoop + 1 > currentLoop)
        {
            SetCurrentSection(0);
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
                SetCurrentSection(currentSectionIndex);
                // animate next section
                // if (currentSectionIndex > sections.Count - 2)
                // {
                //     Debug.Log("Overflow");
                // }
                AnimateSection(currentSectionIndex);
                currentSectionIndex++;
            }
        }
    }

    // Update is called once per frame
    void Update()
    {

        // Get current hand position
        UpdateRightHandPosition();
        // Get animation normalized time
        AnimatorStateInfo animatorStateInfo = modelAnimator.GetCurrentAnimatorStateInfo(0);
        normalizedAnimationTime = animatorStateInfo.normalizedTime;
        // the integral part of normalized time is the amount of
        // loops the animation has already played
        // we only want to  add sections on first pass of animation,
        // that is, when the normalized time is less then 1


        if (currentLoop == 0) // we're in the recording phase
        {
            UpdateCurrentStateText("recording");
            RecordingPhase();
        }
        else // we're in the animation looping phase, not the recording phase
        {
            UpdateCurrentStateText($"playback loop {currentLoop - 1} ({(int)(normalizedAnimationTime % 1 * 100)}%)");
            PlaybackPhase();
        }

    }

    void AnimateSection(int sectionIndex)
    {
        Section section = sections[sectionIndex];

        if (section.isUpwardSection)
        {
            ball.transform.DOMoveY(section.endYPosition + .5f, section.duration);
        }
        else
        {
            ball.transform.DOMoveY(section.endYPosition, section.duration);
        }

    }
    void UpdateRightHandPosition()
    {
        RightHandYPosition = rightHand.position.y;
    }
}

public class Section
{
    public float startYPosition;
    public float endYPosition;
    public float duration;
    public bool isUpwardSection;


}