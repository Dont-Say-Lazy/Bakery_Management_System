</div>
</div>

<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-logo">
                <h3>Acer International Bakery</h3>
                <p>Fresh ingredients, great taste</p>
            </div>
            <div class="footer-links">
                <p>&copy; <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date())%> Acer International Bakery. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>

<style>
    .footer {
        background-color: #ffffff;
        padding: 20px 0;
        margin-top: 40px;
        border-top: 1px solid rgba(77, 208, 197, 0.2);
    }

    .footer-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
    }

    .footer-logo h3 {
        color: #4DD0C5;
        margin: 0;
        font-size: 18px;
    }

    .footer-logo p {
        color: #888888;
        margin: 5px 0 0;
        font-size: 14px;
    }

    .footer-links {
        color: #888888;
        font-size: 14px;
    }

    @media (max-width: 768px) {
        .footer-content {
            flex-direction: column;
            text-align: center;
            gap: 10px;
        }
    }
</style>
</body>
</html>