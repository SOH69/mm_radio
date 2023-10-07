<script lang="ts">
    import { RADIODATA } from '@store/stores'
    import '@fortawesome/fontawesome-free/css/all.min.css'


</script>

<div class="w-full h-[3vh] bg-[#18162F] flex items-center justify-between px-4 text-white text-[1.5vh]">
    <i class="fa-solid fa-satellite-dish animate-pulse animate-infinite animate-duration-100"></i>
    <span class="font-bold">{$RADIODATA.time}</span>
    <i class="fa-solid fa-battery-full"></i>
</div>