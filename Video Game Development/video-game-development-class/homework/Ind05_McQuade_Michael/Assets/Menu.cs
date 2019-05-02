using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Menu : MonoBehaviour
{
    public bool paused = true;
    public Button QuitButton;
    public Button PlayButton;
    public GameObject MenuContainer;
    // Start is called before the first frame update
    void Start()
    {
        QuitButton.onClick.AddListener(QuitClicked);
        PlayButton.onClick.AddListener(PlayClicked);
        Pause();
    }



    public void PlayClicked() {
        Unpause();
    }

    public void QuitClicked() {

        // exit the game
        Application.Quit();
}


    private void hideMenu() {
        MenuContainer.SetActive(false);
    }

    private void showMenu()
    {
        MenuContainer.SetActive(true);
    }

    private void Pause()
    {
        showMenu();
        paused = true;
        Time.timeScale = 0;
    }

    private void Unpause() 
    {
        hideMenu();
        paused = false;
        Time.timeScale = 1;
    }

}
