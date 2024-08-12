export enum Receive {
    radioVisible = 'setRadioVisible',
    updateRadio = 'updateRadio',
    updateTime = 'updateTime',
    radioHide = 'setRadioHide',
    jammer = 'insideJammer',
    notify = 'notify',
    updateRadioList = 'updateRadioList',
    updateRadioTalking = 'updateRadioTalking',
}

export enum Send {
    hide = 'hideUI',
    updateRadioPosition = 'updateRadioPosition',
    updatePlayerPosition = 'updatePlayerListPosition',
    addFavorite = 'addFav',
    removeFavorite = 'removeFav',
    volumeChange = 'volumeChange',
    join = 'join',
    showPlayerList = 'showPlayerList',
    saveData = 'saveData',
    updateRadioSize = 'updateRadioSize',
    allowMovement = 'allowMovement',
    leave = 'leave',
    mute = 'toggleMute',
    getMutedList = 'getMutedList',
    togglemutePlayer = 'togglemutePlayer',
    enableClicks = 'enableClicks',
}
