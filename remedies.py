import random


def detect_dental_issues(image_data):
    conditions = [
        "Dental Cavities",
        "Teeth Discoloration",
        "Plaque Buildup",
        "Mouth Ulcer",
        "Gum Disease"
    ]
    detected_issues = [condition for condition in conditions if random.random() > 0.5]
    return detected_issues


def get_remedy_links(issues):
    remedy_links = {
        "Dental Cavities": [
            "https://www.youtube.com/watch?v=4wlRM-YgRQ8",
            "https://www.youtube.com/watch?v=5EuOZDBJFhc",
            "https://www.youtube.com/watch?v=A6CF1kfFisY",
        ],
        "Teeth Discoloration": [
            "https://www.youtube.com/watch?v=yulO9AmXckc",
            "https://www.youtube.com/watch?v=18rMgzWT_Z4",
            "https://www.youtube.com/watch?v=LiE6mqor5wY",
        ],
        "Plaque Buildup": [
            "https://www.youtube.com/watch?v=IA3pZKYB0ew",
            "https://www.youtube.com/watch?v=Ez_LHZQnWYM",
            "https://www.youtube.com/watch?v=7H6BKFdQQSQ",
        ],
        "Mouth Ulcer": [
            "https://www.youtube.com/watch?v=HQ26zAYwTKQ",
            "https://www.youtube.com/watch?v=UqRpl1Ll5lM",
            "https://www.youtube.com/watch?v=YVuzybMOidI",
        ],
        "Gum Disease": [
            "https://www.youtube.com/watch?v=ggdjx0NVy74",
            "https://www.youtube.com/watch?v=UY8iC8byRh4",
            "https://www.youtube.com/watch?v=ZjLbPJE-zBA",
        ],
    }

    links = [link for issue in issues if issue in remedy_links for link in remedy_links[issue]]
    return links


def main():
    image_data = "oral_image_data"  # Placeholder for image data
    detected_issues = detect_dental_issues(image_data)

    if detected_issues:
        print(f"Detected dental issues: {', '.join(detected_issues)}")

        remedy_links = get_remedy_links(detected_issues)
        print("Here are some YouTube videos for remedies:")
        for link in remedy_links:
            print(link)
    else:
        print("No dental issues detected. Keep maintaining your oral health!")


if __name__ == "__main__":
    main()