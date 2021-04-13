using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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
    [SerializeField]
    private bool isFirstAnimationLoop;
    private Section currentSection;
    [SerializeField]
    private float currentSectionMax;
    [SerializeField]
    private float currentSectionMin;

    [SerializeField]
    private bool isCurrentSectionUpwards;
    [SerializeField]
    private float currentStartTime;

    void Start()
    {
        // initialize list of sections
        sections = new List<Section>();
        // Get current hand position
        UpdateRightHandPosition();
        // Create virtual ball
        ball = Instantiate(BallPrefab);
        // Mark this as the first pass through the animation
        isFirstAnimationLoop = true;
        // slow down the engine
        Time.timeScale = 0.1f;

        AnimatorStateInfo animatorStateInfo = modelAnimator.GetCurrentAnimatorStateInfo(0);
        normalizedAnimationTime = animatorStateInfo.normalizedTime;

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

        if (isFirstAnimationLoop)
        {
            if (normalizedAnimationTime > 1)
            {
                // we're no longer on the first animation loop
                isFirstAnimationLoop = false;
                // TODO: Close out last section?
            }
            else
            {
                // this part of the if statement/update loop happens when 
                // the animation loop is definitely still going on
                if (currentSection is null)
                {
                    // create new section
                    currentSection = new Section(startYPosition: RightHandYPosition);
                    currentSectionMax = RightHandYPosition;
                    currentSectionMin = RightHandYPosition;
                    currentStartTime = Time.time;
                }
                else
                {
                    // set new max and min
                    if (RightHandYPosition > currentSectionMax)
                    {
                        isCurrentSectionUpwards = true;
                        currentSectionMax = RightHandYPosition;
                    }
                    else if (RightHandYPosition < currentSectionMin)
                    {
                        isCurrentSectionUpwards = false;
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
                        sections.Add(currentSection);
                        // set currentSection to null
                        currentSection = null;
                    }

                }

            }
        }
        else
        {
            // TODO: animate virtual ball(s)


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

    public Section(float startYPosition)
    {
        this.startYPosition = startYPosition;
    }
}