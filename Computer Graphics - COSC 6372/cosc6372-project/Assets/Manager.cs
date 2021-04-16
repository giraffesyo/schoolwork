using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

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


    void Start()
    {
        // initialize list of sections
        sections = new List<Section>();
        // Get current hand position
        UpdateRightHandPosition();

        // slow down the engine
        Time.timeScale = 2.0f;
        // BallScript ballScript = GetComponent<BallScript>();
        // ballScript.Target = rightHand.transform;
        // ballScript.Projectile = ball.transform;
        // StartCoroutine(ballScript.SimulateProjectile());
        AnimatorStateInfo animatorStateInfo = modelAnimator.GetCurrentAnimatorStateInfo(0);
        normalizedAnimationTime = animatorStateInfo.normalizedTime;
        currentSectionIndex = 0;
        DOTween.Init();

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


        if (currentLoop == 0)
        {
            if (normalizedAnimationTime >= 1)
            {
                // we're no longer on the first animation loop
                currentLoop++;
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

            // get current loop and compare to stored current loop
            // setup second (and onwards) loops
            int realCurrentLoop = Mathf.FloorToInt(normalizedAnimationTime);

            if (realCurrentLoop + 1 > currentLoop)
            {
                if (currentLoop == 1)
                {
                    // Create virtual ball
                    ball = Instantiate(BallPrefab);
                    ball.transform.position = rightHand.position;
                }
                currentStartTime = Time.time;
                currentSection = sections[0];
                currentSectionIndex = 0;
                currentLoop++;
                // start animation for first section
                AnimateSection(0);
            }

            // get total current runtime of current section
            float currentRunningTime = Time.time - currentStartTime;
            // update the current section we are on
            if (currentSection.duration <= currentRunningTime)
            {
                currentStartTime = Time.time;
                currentSectionIndex++;
                currentSection = sections[currentSectionIndex];
                // animate next section


                AnimateSection(currentSectionIndex);

            }

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

    public Section(float startYPosition)
    {
        this.startYPosition = startYPosition;
    }
}